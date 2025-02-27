#' Draw two oncoplots side by side for cohort comparision.
#' @details Draws two oncoplots side by side to display difference between two cohorts.
#'
#' @param m1 first \code{\link{MAF}} object
#' @param m2 second \code{\link{MAF}} object
#' @param genes draw these genes. Default plots top 5 mutated genes from two cohorts.
#' @param topN NULL(default) or a integer vector of length 1 or 2. if NULL, plot top 5 mutated genes
#'   from two cohorts. if length 1 integer, take plot topN mutated genes from two cohorts. if length
#'   2 interge, plot topN[1] from m1, and topN[2] frm m2 mutated genes.
#' @param clinicalFeatures1 columns names from `clinical.data` slot of m1 \code{MAF} to be drawn in
#'   the plot. Dafault NULL.
#' @param clinicalFeatures2 columns names from `clinical.data` slot of m2 \code{MAF} to be drawn in
#'   the plot. Dafault NULL.
#' @param annotationColor1 list of colors to use for `clinicalFeatures1` Default NULL.
#' @param annotationColor2 list of colors to use for `clinicalFeatures2` Default NULL.
#' @param sortByM1 sort by mutation frequency in `m1`
#' @param sortByM2 sort by mutation frequency in `m2`
#' @param sortByAnnotation1 logical sort oncomatrix (samples) by provided `clinicalFeatures1`. Sorts
#'   based on first `clinicalFeatures1`.  Defaults to FALSE. column-sort
#' @param annotationOrder1 Manually specify order for annotations for `clinicalFeatures1`. Works
#'   only for first value. Default NULL.
#' @param sortByAnnotation2 same as above but for m2
#' @param annotationOrder2 Manually specify order for annotations for `clinicalFeatures2`. Works
#'   only for first value. Default NULL.
#' @param sampleOrder1 Manually specify sample names in m1 for oncolplot ordering. Default NULL.
#' @param sampleOrder2 Manually specify sample names in m2 for oncolplot ordering. Default NULL.
#' @param additionalFeature1 a vector of length two indicating column name in the MAF and the factor
#'   level to be highlighted.
#' @param additionalFeaturePch1 Default 20
#' @param additionalFeatureCol1 Default "white"
#' @param additionalFeatureCex1 Default 0.9
#' @param additionalFeature2 a vector of length two indicating column name in the MAF and the factor
#'   level to be highlighted.
#' @param additionalFeaturePch2 Default 20
#' @param additionalFeatureCol2 Default "white"
#' @param additionalFeatureCex2 Default 0.9
#' @param sepwd_genes1 Default 0.5
#' @param sepwd_samples1 Default 0.5
#' @param sepwd_genes2 Default 0.5
#' @param sepwd_samples2 Default 0.5
#' @param annotationFontSize font size for annotations Default 1.2
#' @param colors named vector of colors for each Variant_Classification.
#' @param removeNonMutated Logical. If \code{TRUE} removes samples with no mutations in the oncoplot
#'   for better visualization. Default \code{TRUE}.
#' @param m1Name optional name for first cohort
#' @param m2Name optional name for second cohort
#' @param geneNamefont font size for gene names. Default 1
#' @param showSampleNames whether to show sample names. Defult FALSE.
#' @param barcode_mar Margin width for sample names. Default 1
#' @param gene_mar Margin width for gene names. Default 1
#' @param outer_mar Margin width for outer. Default 3
#' @param SampleNamefont font size for sample names. Default 0.5
#' @param anno_height Height of clinical margin. Default 2
#' @param legend_height Height of legend margin. Default 4
#' @param lengend_txt_replace the same as `lengend_txt_replace` in oncoplot. Named vector like
#'   c(Frame_Shift_Ins='Amplification', In_Frame_Ins='Gain', In_Frame_Del='Loss',
#'   Frame_Shift_Del='Deletion'). replace standard item like "Frame_Shift_Ins" to custom label like
#'   'Amplification' in figure legend. Do not affect data presentation. Can be used to display CNA
#'   (copy number alteration) data of genes instead of mutations of genes (SNV) of oncoplot, for
#'   both plots differ at figure legends only, CNA prefers "Loss", "Deletion", "Gain", etc in
#'   legend, while SNV prefers "Frame_Shift_Ins", "Frame_Shift_Del", etc in legend.
#' @param legendFontSize font size for legend. Default 1.2
#' @param titleFontSize font size for title. Default 1.5
#' @param keepGeneOrder force the resulting plot to use the order of the genes as specified. Default
#'   FALSE
#' @param bgCol Background grid color for wild-type (not-mutated) samples. Default gray - "#CCCCCC"
#' @param borderCol border grid color for wild-type (not-mutated) samples. Default 'white'
#' @export
#' @examples
#' #' ##Primary and Relapse APL
#' primary.apl <- system.file("extdata", "APL_primary.maf.gz", package = "maftools")
#' relapse.apl <- system.file("extdata", "APL_relapse.maf.gz", package = "maftools")
#' ##Read mafs
#' primary.apl <- read.maf(maf = primary.apl)
#' relapse.apl <- read.maf(maf = relapse.apl)
#' ##Plot
#' coOncoplot(m1 = primary.apl, m2 = relapse.apl, m1Name = 'Primary APL', m2Name = 'Relapse APL')
#' dev.off()
#' @return Invisibly returns a list of sample names in their order of occurrences in M1 and M2
#'   respectively.
#'
coOncoplot = function(m1, m2, genes = NULL, topN = NULL, m1Name = NULL, m2Name = NULL,
                       clinicalFeatures1 = NULL, clinicalFeatures2 = NULL,
                       annotationColor1 = NULL, annotationColor2 = NULL, annotationFontSize = 1.2, sortByM1 = FALSE, sortByM2 = FALSE,
                       sortByAnnotation1 = FALSE, annotationOrder1 = NULL, sortByAnnotation2 = FALSE, annotationOrder2 = NULL,
                      sampleOrder1 = NULL, sampleOrder2 = NULL,
                      additionalFeature1 = NULL, additionalFeaturePch1 = 20, additionalFeatureCol1 = "white", additionalFeatureCex1 = 0.9,
                      additionalFeature2 = NULL, additionalFeaturePch2 = 20, additionalFeatureCol2 = "white", additionalFeatureCex2 = 0.9,
                      sepwd_genes1 = 0.5, sepwd_samples1 = 0.5, sepwd_genes2 = 0.5, sepwd_samples2 = 0.5,
                       colors = NULL, removeNonMutated = TRUE, anno_height = 2, legend_height = 4, lengend_txt_replace = NULL,
                       geneNamefont = 0.8, showSampleNames = FALSE, SampleNamefont = 0.5, barcode_mar = 1, outer_mar = 3, gene_mar = 1,
                       legendFontSize = 1.2, titleFontSize = 1.5, keepGeneOrder=FALSE,
                       bgCol = "#CCCCCC", borderCol = "white"){
  if(is.null(genes)){
    if (is.null(topN)){
      topN = 5L
    }else{
      topN = as.integer(topN)
    }
    if (length(topN)==1){
      genes = unique(c(getGeneSummary(m1)[1:topN, Hugo_Symbol], getGeneSummary(m2)[1:topN, Hugo_Symbol]))
      message('There are [',topN * 2 - length(genes),'] overlapping genes in top ',topN,' genes from m1 group, and top ',topN,' genes from m2 group')
    }else if(length(topN)==2){
      genes = unique(c(getGeneSummary(m1)[1:topN[1], Hugo_Symbol], getGeneSummary(m2)[1:topN[2], Hugo_Symbol]))
      message('There are [',sum(topN) - length(genes),'] overlapping genes in top ', topN[1],' genes in m1 group and top ',topN[2],' genes in m2 group')
    }else{
      stop('! wrong format of topN, should be NULL or interger c(N) or c(N1,N2)')
    }
  }

  m1.genes = getGeneSummary(x = m1)[Hugo_Symbol %in% genes]
  m2.genes = getGeneSummary(x = m2)[Hugo_Symbol %in% genes]
    mdt = merge(m1.genes[,.(Hugo_Symbol, MutatedSamples)], m2.genes[,.(Hugo_Symbol, MutatedSamples)], by = 'Hugo_Symbol', all = TRUE, suffixes = c("_m1", "_m2"))
    mdt$MutatedSamples_m1[is.na(mdt$MutatedSamples_m1)] = 0
    mdt$MutatedSamples_m2[is.na(mdt$MutatedSamples_m2)] = 0
    mdt$max = apply(mdt[,.(MutatedSamples_m1, MutatedSamples_m2)], 1, max)
    if(sortByM1){
      mdt = mdt[order(MutatedSamples_m1, decreasing = TRUE)]
    }else if(sortByM2){
      mdt = mdt[order(MutatedSamples_m2, decreasing = TRUE)]
    }else{
      mdt = mdt[order(max, decreasing = TRUE)]
    }

    genes = mdt[,Hugo_Symbol]

  m1.sampleSize = m1@summary[3, summary]
  m2.sampleSize = m2@summary[3, summary]


  if(is.null(m1Name)){
    m1Name = 'M1'
  }

  m1Name = paste(m1Name, ' (N = ' , m1.sampleSize, ')',sep = '')

  if(is.null(m2Name)){
    m2Name = 'M2'
  }

  m2Name = paste(m2Name, ' (N = ' , m2.sampleSize, ')',sep = '')

  if(is.null(colors)){
    vc_col = get_vcColors(websafe = FALSE)
  }else{
    vc_col = colors
  }

  m12_annotation_colors = NULL
  if(!is.null(clinicalFeatures1) & !is.null(clinicalFeatures2)){
    if(is.null(annotationColor1) & is.null(annotationColor2)){
      m12_annotation_colors = get_m12_annotation_colors(a1 = m1, a1_cf = clinicalFeatures1,
                                                        a2 = m2, a2_cf = clinicalFeatures2)
      annotationColor1 = m12_annotation_colors
      annotationColor2 = m12_annotation_colors
    }
  }

  #Get matrix dimensions and legends to adjust plot graphics::layout
  nm1 = print_mat(maf = m1, genes = genes, removeNonMutated = removeNonMutated,
                  test = TRUE, colors = colors)
  nm1_ncol = ncol(nm1[[1]])
  nm1_vc_cols = nm1[[2]]

  nm2 = print_mat(maf = m2, genes = genes, removeNonMutated = removeNonMutated,
                  test = TRUE, colors = colors)
  nm2_ncol = ncol(nm2[[1]])
  nm2_vc_cols = nm2[[2]]

  if(!is.null(clinicalFeatures1) || !is.null(clinicalFeatures2)){
    mat_lo = matrix(data = c(1,3,5,2,4,6,7,7,7), nrow = 3, ncol = 3, byrow = TRUE)
    mat_lo = graphics::layout(mat = mat_lo,
                    widths = c(6 * (nm1_ncol/nm2_ncol), gene_mar, 6), heights = c(12, anno_height, legend_height))
  }else{
    mat_lo = matrix(data = c(1,2,3,4,4,4), nrow = 2, ncol = 3, byrow = TRUE)
    mat_lo = graphics::layout(mat = mat_lo,
                    widths = c(6 * (nm1_ncol/nm2_ncol), gene_mar, 6), heights = c(12, legend_height))
  }

  #Plot first oncoplot
  m1_legend = print_mat(maf = m1, genes = genes, removeNonMutated = removeNonMutated,
                        clinicalFeatures = clinicalFeatures1, colors = colors,
                        annotationColor = annotationColor1, barcode_size = SampleNamefont,
                        sortByAnnotation = sortByAnnotation1, annotationOrder = annotationOrder1, fontSize = geneNamefont,
                        title = m1Name, title_size = titleFontSize,
                        showBarcodes = showSampleNames, bgCol = bgCol, borderCol = borderCol,
                        additionalFeature = additionalFeature1, additionalFeaturePch = additionalFeaturePch1,
                        additionalFeatureCex = additionalFeatureCex1, additionalFeatureCol = additionalFeatureCol1,
                        sepwd_genes = sepwd_genes1, sepwd_samples = sepwd_samples1, barcodemar = barcode_mar, genemar = outer_mar, sampleOrder = sampleOrder1)
  m1_samp_order = m1_legend$sampOrder
  m1_legend = m1_legend[[2]]


  if(is.null(clinicalFeatures1) & !is.null(clinicalFeatures2)){
    plot.new()
  }

  if(showSampleNames){
    par(mar = c(barcode_mar, 0, 3, 0))
  }else{
    par(mar = c(1, 0, 3, 0))
  }

  #Plot gene names
  nm = matrix(data = 1, nrow = 1, ncol = length(genes))
  image(x = 1:nrow(nm), y = 1:ncol(nm), z = nm, axes = FALSE, xaxt="n", yaxt="n",
        xlab="", ylab="", col = "white")
  text(x = nrow(nm), y = 1:ncol(nm), labels = rev(genes), xpd = TRUE, font = 3, cex = geneNamefont*1.5)
  # mtext(text = rev(genes), side = 2, adj = 0.5, at = 1:ncol(nm),
  #       font = 3, line = -2, cex = geneNamefont, las = 2)

  if(!is.null(clinicalFeatures1) || !is.null(clinicalFeatures2)){
    plot.new()
  }

  m2_legend = print_mat(maf = m2, genes = genes, removeNonMutated = removeNonMutated,
                        clinicalFeatures = clinicalFeatures2, colors = colors,
                        annotationColor = annotationColor2, barcode_size = SampleNamefont,
                        sortByAnnotation = sortByAnnotation2, annotationOrder = annotationOrder2, fontSize = geneNamefont,
                        title = m2Name, title_size = titleFontSize, plot2 = TRUE,
                        showBarcodes = showSampleNames, bgCol = bgCol, borderCol = borderCol,
                        additionalFeature = additionalFeature2, additionalFeaturePch = additionalFeaturePch2,
                        additionalFeatureCex = additionalFeatureCex2, additionalFeatureCol = additionalFeatureCol2,
                        sepwd_genes = sepwd_genes2, sepwd_samples = sepwd_samples2, barcodemar = barcode_mar, genemar = outer_mar, sampleOrder = sampleOrder2)
  m2_samp_order = m2_legend$sampOrder
  m2_legend = m2_legend[[2]]

  if(!is.null(clinicalFeatures1) & is.null(clinicalFeatures2)){
    plot.new()
  }

  vc_legend = list(nm1_vc_cols, nm2_vc_cols)
  vc_legend = unlist(vc_legend)[unique(names(unlist(vc_legend)))]
  #vc_legend = vc_col[vc_legend]
  vc_legend = vc_legend[!is.na(vc_legend)]

  if(is.null(m12_annotation_colors)){
    anno_legend = c(m1_legend, m2_legend)
  }else{
    anno_legend = m12_annotation_colors
  }

  par(mar = c(1, 1, 0, 0), xpd = TRUE)

  vc_pch = rep(15, length(vc_legend))
  if(!is.null(additionalFeature1)){

    if(!is(object = additionalFeature1, class2 = "list")){
      if(length(additionalFeature1) < 2){
        stop("additionalFeature must be of length two. See ?oncoplot for details.")
      }else{
        additionalFeature1 = list(additionalFeature1)
      }
    }

    if(length(additionalFeaturePch1) != length(additionalFeature1)){
      additionalFeaturePch1 = rep(additionalFeaturePch1, length(additionalFeature1))
    }

    if(length(additionalFeatureCol1) != length(additionalFeature1)){
      additionalFeatureCol1 = rep(additionalFeatureCol1, length(additionalFeature1))
    }

    for(af_idx in 1:length(additionalFeature1)){
      af = additionalFeature1[[af_idx]]
      vc_legend = c(vc_legend, additionalFeatureCol1[af_idx])
      names(vc_legend)[length(vc_legend)] = paste(af, collapse = ":")
      vc_pch = c(vc_pch, additionalFeaturePch1[af_idx])
    }
  }

  if(!is.null(additionalFeature2)){

    if(!is(object = additionalFeature2, class2 = "list")){
      if(length(additionalFeature2) < 2){
        stop("additionalFeature must be of length two. See ?oncoplot for details.")
      }else{
        additionalFeature2 = list(additionalFeature2)
      }
    }

    if(length(additionalFeaturePch2) != length(additionalFeature2)){
      warning("Provided pch for additional features are recycled")
      additionalFeaturePch2 = rep(additionalFeaturePch2, length(additionalFeature2))
    }

    if(length(additionalFeatureCol2) != length(additionalFeature2)){
      warning("Provided colors for additional features are recycled")
      additionalFeatureCol2 = rep(additionalFeatureCol2, length(additionalFeature2))
    }

    for(af_idx in 1:length(additionalFeature2)){
      af = additionalFeature2[[af_idx]]
      vc_legend = c(vc_legend, additionalFeatureCol2[af_idx])
      names(vc_legend)[length(vc_legend)] = paste(af, collapse = ":")
      vc_pch = c(vc_pch, additionalFeaturePch2[af_idx])
    }
  }

  plot(NULL,ylab='',xlab='', xlim=0:1, ylim=0:1, axes = FALSE)

  if (!is.null(lengend_txt_replace)){
    if (typeof(lengend_txt_replace) == 'list'){
      lengend_txt_replace = unlist(lengend_txt_replace)
    }
    names.legcls = names(vc_legend)
    names.legcls = sapply(names.legcls, function(i){x = lengend_txt_replace[i];if(is.na(x))i else x},USE.NAMES=FALSE)
    names(vc_legend) = names.legcls
  }

  lep = legend("topleft", legend = names(vc_legend),
               col = vc_legend, border = NA, bty = "n",
               ncol= 2, pch = vc_pch, xpd = TRUE, xjust = 0, yjust = 0, cex = legendFontSize)

  x_axp = 0+lep$rect$w

  if(!is.null(anno_legend)){

    for(i in 1:length(anno_legend)){
      #x = unique(annotation[,i])
      x = anno_legend[[i]]

      if(length(x) <= 4){
        n_col = 1
      }else{
        n_col = (length(x) %/% 4)+1
      }

      lep = legend(x = x_axp, y = 1, legend = names(x),
                   col = x, border = NA,
                   ncol= n_col, pch = 15, xpd = TRUE, xjust = 0, bty = "n",
                   cex = annotationFontSize, title = names(anno_legend)[i], title.adj = 0)
      x_axp = x_axp + lep$rect$w

    }
  }

  invisible(x = list(M1_sample_order = m1_samp_order, M2_sample_order = m2_samp_order))
}
