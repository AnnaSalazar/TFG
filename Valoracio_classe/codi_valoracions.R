library(ggplot2)

# Lectura de les dades per cada apartat
a <- c(3, 5, 6, 9, 5, 4, 7, 4, 9, 6, 7, 6, 5, 4, 6, 5, 4, 3)
b <- c(4, 3, 3, 7, 0, 2, 4, 4, 2, 7, 10, 4, 2, 5, 8, 4, 3, 1)
c <- c(7, 4, 7, 8, 3, 3, 8, 6, 5, 7, 8, 6, 6, 7, 7, 8, 3, 5)
d <- c(5, 6, 5, 7, 2, 3, 7, 6.5, 6, 8, 9, 6.5, 5, 8, 7, 9.5, 3)

# Càlcul mitjanes
(mean_a <- round(sum(a)/length(a),4))
(mean_b <- round(sum(b)/length(b),4))
(mean_c <- round(sum(c)/length(c),4))
(mean_d <- round(sum(d)/length(d),4))

dades <- data.frame(Items = factor(c(rep("Connexió BigQuery", length(a)),
                                     rep("Consultes SQL BigQuery", length(b)),
                                     rep("Connexió amb R", length(c)),
                                     rep("Valoració global", length(d)))), Valoracio = c(a,b,c,d))

ggplot(dades, aes(x=Items, y=Valoracio)) +
  geom_boxplot(fill = "#1d91c0") + ylab("Valoració mitjana") +
  xlab("") + theme_minimal()
