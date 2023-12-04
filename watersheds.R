qgis_configure()

install.packages("remotes")
remotes::install_github("paleolimbot/qgisprocess")

remotes::install_github("r-spatial/qgisprocess")

install.packages("devtools")
devtools:::install_github("gearslaboratory/gdalUtils")

library(remotes)
library(gdalUtils)
library(qgisprocess)
#library(terra)
#qgis_path()
#qgis_version()

# This function returns a data frame containing all of 
# the available providers and the algorithms they contain
qgis_algo = qgis_algorithms()
# run the following code to find the algorithm of interest:
grep("liu", qgis_algo$algorithm, value = TRUE)
grep("watershed", qgis_algo$algorithm, value = TRUE)


mrb <- read_sf("D:\\My Thesis\\watershad.shp")
setwd("D:\\My Thesis\\Homeworks\\4\\dataset-insitu-gridded-observations-global-and-regional-110a9cda-db0e-454c-9b89-6c0f424754b3")
sheep <- raster("GPCC_total_precipitation_mon_0.5x0.5_global_1891_v2020.0.tif")
#load DEM and change extend
setwd('D:\\My Thesis\\Documents\\DEM')
DEM <- raster("DEM_05deg.tif")
DEM <- mask(DEM,sheep)
DEM[DEM <= 0] <- NA

# Load flow data
setwd("D:\\My Thesis\\Homeworks\\Grun")
N.manure <- raster("GRUN_v1_GSWP3_WGS84_05_1902_2014.nc")
N.manure <- resample(N.manure, sheep, "bilinear")
N.manure <- mask(N.manure,sheep)

setwd("D:\\My Thesis\\watershad")

start_time <- Sys.time()
for (i in 1:520) {
#local DEM for specific mrb
#which(MB.name=="CHAD",arr.ind=TRUE)
l_DEM <- crop(DEM,mrb[i,9])
#l_DEM <- mask(l_DEM,mrb[500,9])

#local flow for specific mrb
flow <- crop(N.manure,mrb[i,9])
#flow <- mask(flow,mrb[1,9])
mc <- makeCluster(detectCores())
registerDoParallel(mc)

filled <-  qgis_run_algorithm("saga:fillsinkswangliu", ELEV = l_DEM)
filled_DEM <- raster(filled$FILLED[1])

delineate_flow <-  qgis_run_algorithm("grass7:r.watershed", elevation = filled_DEM,
                                 flow = flow,'-a' = TRUE, threshold = 5000)
delineate_flow <- raster(delineate_flow$accumulation[1])


delineate <-  qgis_run_algorithm("grass7:r.watershed", elevation = filled_DEM,
                                 '-a' = TRUE, threshold = 5000, overwrite = TRUE)
delineate <- raster(delineate$accumulation[1])

r <- delineate_flow/delineate
raster.name <- paste0("watershed_", i)
assign(raster.name, r)

rm(l_DEM, flow, filled, filled_DEM, delineate, delineate_flow, r)
gc()

}

end_time <- Sys.time()
end_time - start_time


raster.names <- "watershed_1"
for (i in 2:520) {
  raster.names <- paste0(raster.names,",watershed_",i)
}


x <- list(watershed_1,watershed_2,watershed_3,watershed_4,watershed_5,
          watershed_6,watershed_7,watershed_8,watershed_9,watershed_10,
          watershed_11,watershed_12,watershed_13,watershed_14,watershed_15,
          watershed_16,watershed_17,watershed_18,watershed_19,watershed_20,
          watershed_21,watershed_22,watershed_23,watershed_24,watershed_25,
          watershed_26,watershed_27,watershed_28,watershed_29,watershed_30,
          watershed_31,watershed_32,watershed_33,watershed_34,watershed_35,
          watershed_36,watershed_37,watershed_38,watershed_39,watershed_40,
          watershed_41,watershed_42,watershed_43,watershed_44,watershed_45,
          watershed_46,watershed_47,watershed_48,watershed_49,watershed_50,
          watershed_51,watershed_52,watershed_53,watershed_54,watershed_55,
          watershed_56,watershed_57,watershed_58,watershed_59,watershed_60,
          watershed_61,watershed_62,watershed_63,watershed_64,watershed_65,
          watershed_66,watershed_67,watershed_68,watershed_69,watershed_70,
          watershed_71,watershed_72,watershed_73,watershed_74,watershed_75,
          watershed_76,watershed_77,watershed_78,watershed_79,watershed_80,
          watershed_81,watershed_82,watershed_83,watershed_84,watershed_85,
          watershed_86,watershed_87,watershed_88,watershed_89,watershed_90,
          watershed_91,watershed_92,watershed_93,watershed_94,watershed_95,
          watershed_96,watershed_97,watershed_98,watershed_99,watershed_100,
          watershed_101,watershed_102,watershed_103,watershed_104,watershed_105,
          watershed_106,watershed_107,watershed_108,watershed_109,watershed_110,
          watershed_111,watershed_112,watershed_113,watershed_114,watershed_115,
          watershed_116,watershed_117,watershed_118,watershed_119,watershed_120,
          watershed_121,watershed_122,watershed_123,watershed_124,watershed_125,
          watershed_126,watershed_127,watershed_128,watershed_129,watershed_130,
          watershed_131,watershed_132,watershed_133,watershed_134,watershed_135,
          watershed_136,watershed_137,watershed_138,watershed_139,watershed_140,
          watershed_141,watershed_142,watershed_143,watershed_144,watershed_145,
          watershed_146,watershed_147,watershed_148,watershed_149,watershed_150,
          watershed_151,watershed_152,watershed_153,watershed_154,watershed_155,
          watershed_156,watershed_157,watershed_158,watershed_159,watershed_160,
          watershed_161,watershed_162,watershed_163,watershed_164,watershed_165,
          watershed_166,watershed_167,watershed_168,watershed_169,watershed_170,
          watershed_171,watershed_172,watershed_173,watershed_174,watershed_175,
          watershed_176,watershed_177,watershed_178,watershed_179,watershed_180,
          watershed_181,watershed_182,watershed_183,watershed_184,watershed_185,
          watershed_186,watershed_187,watershed_188,watershed_189,watershed_190,
          watershed_191,watershed_192,watershed_193,watershed_194,watershed_195,
          watershed_196,watershed_197,watershed_198,watershed_199,watershed_200,
          watershed_201,watershed_202,watershed_203,watershed_204,watershed_205,
          watershed_206,watershed_207,watershed_208,watershed_209,watershed_210,
          watershed_211,watershed_212,watershed_213,watershed_214,watershed_215,
          watershed_216,watershed_217,watershed_218,watershed_219,watershed_220,
          watershed_221,watershed_222,watershed_223,watershed_224,watershed_225,
          watershed_226,watershed_227,watershed_228,watershed_229,watershed_230,
          watershed_231,watershed_232,watershed_233,watershed_234,watershed_235,
          watershed_236,watershed_237,watershed_238,watershed_239,watershed_240,
          watershed_241,watershed_242,watershed_243,watershed_244,watershed_245,
          watershed_246,watershed_247,watershed_248,watershed_249,watershed_250,
          watershed_251,watershed_252,watershed_253,watershed_254,watershed_255,
          watershed_256,watershed_257,watershed_258,watershed_259,watershed_260,
          watershed_261,watershed_262,watershed_263,watershed_264,watershed_265,
          watershed_266,watershed_267,watershed_268,watershed_269,watershed_270,
          watershed_271,watershed_272,watershed_273,watershed_274,watershed_275,
          watershed_276,watershed_277,watershed_278,watershed_279,watershed_280,
          watershed_281,watershed_282,watershed_283,watershed_284,watershed_285,
          watershed_286,watershed_287,watershed_288,watershed_289,watershed_290,
          watershed_291,watershed_292,watershed_293,watershed_294,watershed_295,
          watershed_296,watershed_297,watershed_298,watershed_299,watershed_300,
          watershed_301,watershed_302,watershed_303,watershed_304,watershed_305,
          watershed_306,watershed_307,watershed_308,watershed_309,watershed_310,
          watershed_311,watershed_312,watershed_313,watershed_314,watershed_315,
          watershed_316,watershed_317,watershed_318,watershed_319,watershed_320,
          watershed_321,watershed_322,watershed_323,watershed_324,watershed_325,
          watershed_326,watershed_327,watershed_328,watershed_329,watershed_330,
          watershed_331,watershed_332,watershed_333,watershed_334,watershed_335,
          watershed_336,watershed_337,watershed_338,watershed_339,watershed_340,
          watershed_341,watershed_342,watershed_343,watershed_344,watershed_345,
          watershed_346,watershed_347,watershed_348,watershed_349,watershed_350,
          watershed_351,watershed_352,watershed_353,watershed_354,watershed_355,
          watershed_356,watershed_357,watershed_358,watershed_359,watershed_360,
          watershed_361,watershed_362,watershed_363,watershed_364,watershed_365,
          watershed_366,watershed_367,watershed_368,watershed_369,watershed_370,
          watershed_371,watershed_372,watershed_373,watershed_374,watershed_375,
          watershed_376,watershed_377,watershed_378,watershed_379,watershed_380,
          watershed_381,watershed_382,watershed_383,watershed_384,watershed_385,
          watershed_386,watershed_387,watershed_388,watershed_389,watershed_390,
          watershed_391,watershed_392,watershed_393,watershed_394,watershed_395,
          watershed_396,watershed_397,watershed_398,watershed_399,watershed_400,
          watershed_401,watershed_402,watershed_403,watershed_404,watershed_405,
          watershed_406,watershed_407,watershed_408,watershed_409,watershed_410,
          watershed_411,watershed_412,watershed_413,watershed_414,watershed_415,
          watershed_416,watershed_417,watershed_418,watershed_419,watershed_420,
          watershed_421,watershed_422,watershed_423,watershed_424,watershed_425,
          watershed_426,watershed_427,watershed_428,watershed_429,watershed_430,
          watershed_431,watershed_432,watershed_433,watershed_434,watershed_435,
          watershed_436,watershed_437,watershed_438,watershed_439,watershed_440,
          watershed_441,watershed_442,watershed_443,watershed_444,watershed_445,
          watershed_446,watershed_447,watershed_448,watershed_449,watershed_450,
          watershed_451,watershed_452,watershed_453,watershed_454,watershed_455,
          watershed_456,watershed_457,watershed_458,watershed_459,watershed_460,
          watershed_461,watershed_462,watershed_463,watershed_464,watershed_465,
          watershed_466,watershed_467,watershed_468,watershed_469,watershed_470,
          watershed_471,watershed_472,watershed_473,watershed_474,watershed_475,
          watershed_476,watershed_477,watershed_478,watershed_479,watershed_480,
          watershed_481,watershed_482,watershed_483,watershed_484,watershed_485,
          watershed_486,watershed_487,watershed_488,watershed_489,watershed_490,
          watershed_491,watershed_492,watershed_493,watershed_494,watershed_495,
          watershed_496,watershed_497,watershed_498,watershed_499,watershed_500,
          watershed_501,watershed_502,watershed_503,watershed_504,watershed_505,
          watershed_506,watershed_507,watershed_508,watershed_509,watershed_510,
          watershed_511,watershed_512,watershed_513,watershed_514,watershed_515,
          watershed_516,watershed_517,watershed_518,watershed_519,watershed_520)

names(x)[1:2] <- c('x', 'y')
x$fun <- mean
x$na.rm <- TRUE
mc <- makeCluster(detectCores())
registerDoParallel(mc)
y <- do.call(mosaic, x)
yy <- resample(y, N.manure, "bilinear")
z <- merge(yy,N.manure)

setwd("D:\\My Thesis\\watershad\\runoff watershed")
writeRaster(z, "N.runoff_upstream.tif", "GTiff")



