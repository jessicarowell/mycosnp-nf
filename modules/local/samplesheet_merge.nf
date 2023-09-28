process SAMPLESHEET_MERGE {
    tag "$samplesheet"

    conda (params.enable_conda ? "conda-forge::perl=5.22.2.1" : null)
    container 'quay.io/biocontainers/perl:5.22.2.1'

    input:
    path(samplesheet)

    output:
    path 'samplesheet.system.csv'  , emit: csv

    script: // This script is bundled with the pipeline, in nf-core/mycosnp/bin/
    """
    mycosnp_combine_lanes.pl -i $samplesheet > samplesheet.system.csv

    # TODO: Add version
    
    """
}
