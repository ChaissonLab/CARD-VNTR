# Example workflow
# Declare WDL version 1.0 if working in Terra
version 1.0

workflow vamos {

    input {
        File BAM
        File BAM_INDEX
        File MOTIFS
        String SAMPLE = basename(BAM, ".bam")
    }

    call vamosTest {
        input:
        bam = BAM,
        bam_index = BAM_INDEX,
        motifs = MOTIFS,
        sample = SAMPLE
    }

    output {
        File out_vcf = vamosTest.outVCF
    }
}

task vamosTest {
    input {
        File bam
        File bam_index
        File motifs
        String sample
        Int cpu = 1
        Int mem = 8
    }

    command <<<
        vamos --contig -b ~{bam} -r ~{motifs} -s ~{sample} -o ~{sample}.vcf
    >>>

    output {
        File outVCF = "~{sample}.vcf"
    }

    runtime {
        docker: "mchaisso/vamos:1.2.6"
        cpu: cpu
        memory: mem+"GB"
    }
}

