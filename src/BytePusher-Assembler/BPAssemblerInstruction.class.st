Class {
	#name : #BPAssemblerInstruction,
	#superclass : #Object,
	#category : #'BytePusher-Assembler-Assembler'
}

{ #category : #generating }
BPAssemblerInstruction >> generateFor: anAssembler [
	"Generate BPInstructionToResolve and add them to anAssembler."
	self subclassResponsibility
]
