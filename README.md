# Kilo-seq / barcode-seq pipeline

Chung-Wen Lin

**2021.03.17 16:24** -

1. using `bowtie2-build` to create the index of reference sequences

```
bowtie2-build $HOME/workplace/database/Homo_sapiens/hORF_v9.1.fasta \\
    hORFv9 \\
    --threads 12
```

2. using `bowtie2` to align target/query reads onto the reference index
```
bowtie2 -p 12 -x $HOME/data/index/hORFv9 \\
    -f $HOME/data/fasta/Vero-AD_S49_L001_R1_001.fasta \\
    -S Vero-AD_S49_L001_R1_001.hORF.sam \\
    2>Vero-AD_S49_L001_R1_001.hORF.log
```

3. extract alignment result from established sam file with custom perl script
```
perl $HOME/Documents/INET-work/INETscripts/sam_output_seq.pl Vero-1_S51_L001_R2_001.sam > Vero_1_S51_R2.tsv
```

4. calculate the matched plate-well probability with custom Rmarkdown

Rscript Y1H_probability

------

## [Sequence Alignment/Map Format Specification (SAM)](https://samtools.github.io/hts-specs/SAMv1.pdf)

mandatory fields in the SAM file
| Field | Type | Brief description | explanation |
|-------|------|-----------|-----------|
| QNAME |string | Query template name |  |
| FLAG | Int | bitwise FLAG |  |
| RNAME | string | reference sequence name |  |
| POS | Int | 1-based leftmost mapping POSition |  |
| MAPQ | Int | MAPping quality | equals −10 log10 Pr{mapping position is wrong}, rounded to the nearest integer |
| CIGAR | string | CIGAR string | showing the matching situation |
| RNEXT | string | Reference name of the mate/next read | |
| PNEXT | Int | Position of the mate/next read | |
| TLEN | Int | observed template length | |
| SEQ | string | segment sequence | |
| QUAL | string | ASCII of Phred-scaled base QUALity+33 | |
