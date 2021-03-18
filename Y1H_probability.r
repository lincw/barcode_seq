library(dplyr)
library(data.table)
dir1 <- "~/workplace/barcode_seq/Ram/result/TFs"
dir2 <- "~/workplace/barcode_seq/Ram/result/barcodes"
data1_f <- list.files(dir1, pattern = "\\.tsv")
data2_f <- list.files(dir2, pattern = "\\.tsv")

all <- list()
for (i in 1:length(data1_f)) {
    tf_name <- list.files(dir1, pattern = data1_f[i])
    bar_name <- list.files(dir2, pattern = data2_f[i])
    pair_name <- strsplit(tf_name, "_")[[1]][1]
    if (!is.na(pmatch("Vero", pair_name) == 1)) {
        next
    } else {
        data1 <- read.table(file.path(dir1, tf_name), header = T)
        data1_sub <- data1[, c(1, 2)]
        data2 <- read.table(file.path(dir2, bar_name), header = T)
        data2_sub <- data2[, c(1, 2)]

        q_merge <- merge(data1_sub, data2_sub, by.x = "queryID", by.y = "queryID")
        q_merge$well <- substr(q_merge$"matchID.y", nchar(q_merge$"matchID.y") - 2, nchar(q_merge$"matchID.y"))
        df <- q_merge %>% group_by(well) %>% count(matchID.x) %>% mutate(rank = dense_rank(desc(n)))
        df_d <- data.table(df)
        df_s <- df_d[, sum(n), by = well]
        df_final <- merge(df_d, df_s, by.x = "well", by.y = "well")
        df_final$probability <- df_final$n / df_final$V1
        df_final$plate <- pair_name
        names(df_final) <- c("well", "TF_locus", "matched read for TF", "rank", "total reads for the well", "probability", "plate")
        df_final <- df_final[, c(7, 1:6)]
        all[[i]] <- df_final
    }
}

write.csv(do.call(rbind.data.frame, all), file = "~/Documents/INET-work/Y1H_promoter/result/barcode_seq/probability/all.csv", row.names = F)
