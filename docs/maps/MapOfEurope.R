# European map from http://editerna.free.fr/wp/?p=130 


library(ggplot2)
library(grid)
library(rworldmap)


# Get the world map
worldMap <- getMap()

# Member States of the European Union
europeanUnion <- c("Austria","Belgium","Bulgaria","Croatia","Cyprus",
                   "Czech Rep.","Denmark","Estonia","Finland","France",
                   "Germany","Greece","Hungary","Ireland","Italy","Latvia",
                   "Lithuania","Luxembourg","Malta","Netherlands","Poland",
                   "Portugal","Romania","Slovakia","Slovenia","Spain",
                   "Sweden","United Kingdom")
# Select only the index of states member of the E.U.
indEU <- which(worldMap$NAME%in%europeanUnion)

# Extract longitude and latitude border's coordinates of members states of E.U.
europeCoords <- lapply(indEU, function(i){
    df <- data.frame(worldMap@polygons[[i]]@Polygons[[1]]@coords)
    df$region =as.character(worldMap$NAME[i])
    colnames(df) <- list("long", "lat", "region")
    return(df)
})

europeCoords <- do.call("rbind", europeCoords)


# Add some data for each member
value <- sample(x = seq(0,3,by = 0.1), size = length(europeanUnion),
                replace = TRUE)
europeanUnionTable <- data.frame(country = europeanUnion, value = value)
europeCoords$value <- europeanUnionTable$value[match(europeCoords$region,europeanUnionTable$country)]


# Plot the map
P <- ggplot() + geom_polygon(data = europeCoords,
                             aes(x = long, y = lat, group = region, fill = value),
                             colour = "black", size = 0.1) +
    coord_map(xlim = c(-13, 35),  ylim = c(32, 71))

P <- P + scale_fill_gradient(name = "Growth Rate", low = "#FF0000FF", high = "#FFFF00FF", na.value = "grey50")

P <- P + theme(#panel.grid.minor = element_line(colour = NA), panel.grid.minor = element_line(colour = NA),
    #panel.background = element_rect(fill = NA, colour = NA),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(), axis.ticks.x = element_blank(),
    axis.ticks.y = element_blank(), axis.title = element_blank(),
    #rect = element_blank(),
    plot.margin = unit(0 * c(-1.5, -1.5, -1.5, -1.5), "lines"))
plot(P)
