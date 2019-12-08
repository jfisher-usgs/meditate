#!/usr/bin/env Rscript

sounds <- list()
sounds[["bowl struck"]] <- audio::load.wave("bowl-struck.wav")
sounds[["bell kyoto"]]  <- audio::load.wave("bell-kyoto.wav")
save(sounds, file="sysdata.rda")

tools::resaveRdaFiles(getwd(), compress="auto")
