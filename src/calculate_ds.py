import pandas as pd
import numpy as np
import xarray as xr
from scipy.stats import lognorm,cumfreq
from scipy.spatial import cKDTree
import xarray as xr
import geopandas

df_build_fac = geopandas.read_file('DATA/bld_sc/bldPort_TV0_siteclasses.shp')
nev=40
pgaxy_all=np.zeros((nev,10000))
for i in range(nev):
    IMFilename_nc='DATA/nc_PGA/sim_IM'+str(i)+'.nc'
    df_tmp=xr.open_dataset(IMFilename_nc)
    df_tmp.close()
    df=df_tmp.to_dataframe()
    pgaxy=np.array(np.sqrt(df.pgax[:10000]*df.pgay[:10000]))
    pgaxy_all[i]=pgaxy


df_locations = pd.read_csv("DATA/LS.input", skiprows=1, names=["nodeID", "x", "y", "z"], delim_whitespace=True)

df_locations_tv=df_locations[:10000]
# Create a cKDTree for locations_coords
locations_coords = df_locations_tv[['x', 'y']]
locations_tree = cKDTree(locations_coords)

# Create a list of tuples for the coordinates in df_build_fac
building_pga_coords = list(zip(df_build_fac['xcoord'], df_build_fac['ycoord']))

# Find the closest points in locations_coords for each point in building_pga_coords
closest_points_indices = locations_tree.query(building_pga_coords, k=1)[1]

building_types = {
    "T1": {
         "medians": [0.057, 0.098, 0.147, 0.223],
        "dispersions": [0.406, 0.404, 0.358, 0.310]
    },
    "T2": {
       
        "medians": [0.057, 0.119, 0.214, 0.361],
        "dispersions": [0.451, 0.349, 0.286, 0.247]
    },
    "T3": {
        "medians": [0.124, 0.175, 0.295, 0.445],
        "dispersions": [0.326, 0.300, 0.254, 0.254]
       
    },
    "T1_upg":{
         "medians": [0.068, 0.118, 0.176, 0.268],
        "dispersions": [0.406, 0.404, 0.358, 0.310]
    },
    "T2_upg":{
          "medians": [0.068, 0.143, 0.257, 0.433],
       "dispersions": [0.451, 0.349, 0.286, 0.247]
    }
}


def calc_dwi(tb,build):
    g=9.81
    eq=[3,4,5,6,10,11,13,15,17,19,21,22,24,28,29,32,34,35,36,37] #######predefined earthquake indices, used for damage calculation
    medians = building_types[tb]['medians']
    dispersions = building_types[tb]['dispersions']
    pga_values=pgaxy_all[eq,closest_points_indices[build]]/g   
    exceedance_probabilities = []
    for pga in pga_values:
        exceedences=np.array([lognorm.cdf(pga, s=dispersion, scale=median) for median, dispersion in zip(medians, dispersions)])
        exact=[exceedences[0]-exceedences[1],exceedences[1]-exceedences[2],exceedences[2]-exceedences[3],exceedences[3]]
        exceedance_probabilities.append(exact)
    weighted_probabilities = []
    for exceedances in exceedance_probabilities:
        weighted_probabilities.append([exceedance * weight for exceedance, weight in zip(exceedances, [1, 2, 3, 4])])
    dwi=weighted_probabilities
    return dwi