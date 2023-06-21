# Example workflow
# Declare WDL version 1.0 if working in Terra
version 1.0

workflow vamos {

    input {
        File BAM
        File BAM_INDEX
        File MOTIFS
        String SAMPLE = basename(BAM, ".bam")
	Int diskSizeGb = 1024
	Int cpu
        Int mem
	Int diskSizeGb
    }

    call vamosAnnotation {
        input:
        bam = BAM,
        bam_index = BAM_INDEX,
        motifs = MOTIFS,
        sample = SAMPLE,
	taskCpu = cpu,
	taskMem = mem,
	taskDiskSizeGb = diskSizeGb	
    }

    output {
        File out_vcf = vamosTest.outVCF
    }
}

task vamosAnnotation {
    input {
        File bam
        File bam_index
        File motifs
        String sample
        Int taskCpu
        Int taskMem
	Int taskDiskSizeGb
    }

    command <<<
        vamos --contig -b ~{bam} -r ~{motifs} -s ~{sample} -o ~{sample}.vcf
    >>>

    output {
        File outVCF = "~{sample}.vcf"
    }

    runtime {
        docker: "mchaisso/vamos:1.2.6"
        cpu: taskCpu
        memory: taskMem+"GB"
	disks: "local-disk " + taskDiskSizeGb + " LOCAL"
    }
}

