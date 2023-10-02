# Example workflow
# Declare WDL version 1.0 if working in Terra
version 1.0

workflow vamos {

    input {
        File BAM
	File BAI
        File MOTIFS
        String SAMPLE = basename(BAM, ".bam")
	Int cpu
        Int mem
	Int diskSizeGb
	String mode
    }

    call vamosAnnotation {
        input:
        bam = BAM,
        motifs = MOTIFS,
        sample = SAMPLE,
	taskCpu = cpu,
	taskMem = mem,
	taskDiskSizeGb = diskSizeGb,
	taskMode = mode
    }

    output {
        File out_vcf =  glob("*.vcf")[0]
    }
}

task vamosAnnotation {
    input {
        File bam
	File bai
        File motifs
        String sample
        Int taskCpu
        Int taskMem
	Int taskDiskSizeGb
	String taskMode
    }

    command <<<
        vamos ~{taskMode} -b ~{bam} -r ~{motifs} -s ~{sample} -o ~{sample}.vcf -t ~{taskCpu}
    >>>

    output {
        File outVCF = glob("*.vcf")[0]
    }

    runtime {
        docker: "mchaisso/vamos:1.3.6"
        cpu: taskCpu
        memory: taskMem+"GB"
	disks: "local-disk " + taskDiskSizeGb + " LOCAL"
    }
}

