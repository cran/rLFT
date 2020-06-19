## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(rLFT)
library(ggplot2)
# read in example data
data("shpObject")
# to read in your own shp file use the sf package function st_read()
# choose any positive window size and step size. Here I use 50 for step size and 100 for window size.
outputTable <- bct(shpObject, step = 50, window = 100, ridName = "RID")
outputTable$RID<- as.character(outputTable$RID)
# You can then look over the data using:
head(outputTable)


## ----fig.align='center', fig.height=5, fig.width=6----------------------------
# Make the table spatially aware
outSF<- st_as_sf(outputTable, coords = c("Midpoint_X", "Midpoint_Y"), crs = st_crs(shpObject), stringsAsFactors = FALSE)

# plot a single island
ggplot(data = outSF[which(outSF$RID == as.character(shpObject$RID[15])), ]) +
  geom_sf(data = st_cast(shpObject[15,], "POLYGON"), aes(fill = RID)) +
  geom_sf() +
  geom_sf_text(aes(label = RawConvexity), nudge_x = 20, nudge_y = 12) +
  theme_classic()


## -----------------------------------------------------------------------------
data("shpObject")
monly <- shpObject

#Display coordinates
print("No M Values")
head(st_coordinates(monly))

## -----------------------------------------------------------------------------
# Assign M values to each vertex
monly <- addMValues(monly)

print("M Values Added")
head(st_coordinates(monly))

