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

{ #category : #factory }
BPAssemblerInstruction >> newInstruction [
	"Creates an instruction to be resolved later.
	 The aim of this factory is to set specific meta-data on the instruction depending
	 on the assembler instruction from which it is originated.
	"
	self flag: #TODO. "Add meta-data."
	^ BPInstructionToResolve new
]
