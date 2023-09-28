process BCFTOOLS_CONSENSUS {
    tag "$meta.id"
    label 'process_medium'

    conda (params.enable_conda ? 'bioconda::bcftools=1.14' : null)
    container 'quay.io/biocontainers/bcftools:1.14--h88f3f91_0'

    input:
    tuple val(meta), path(vcf), path(tbi), path(fasta)

    output:
    tuple val(meta), path('*.fa'), emit: fasta
    path  "versions.yml"         , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    cat $fasta \\
        | bcftools \\
            consensus \\
            $vcf \\
            $args \\
            > ${prefix}.fa

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        bcftools: \$(bcftools --version 2>&1 | head -n1 | sed 's/^.*bcftools //; s/ .*\$//')
    END_VERSIONS
    """
}
