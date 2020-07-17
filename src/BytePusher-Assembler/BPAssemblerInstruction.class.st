Class {
	#name : #BPAssemblerInstruction,
	#superclass : #Object,
	#instVars : [
		'assemblerInstructionForNewInstructions'
	],
	#category : #'BytePusher-Assembler-Assembler'
}

{ #category : #accessing }
BPAssemblerInstruction >> assemblerInstructionForNewInstructions [
	^ assemblerInstructionForNewInstructions
]

{ #category : #accessing }
BPAssemblerInstruction >> assemblerInstructionForNewInstructions: anObject [
	assemblerInstructionForNewInstructions := anObject
]

{ #category : #generating }
BPAssemblerInstruction >> generateFor: anAssembler [
	"Generate BPInstructionToResolve and add them to anAssembler."
	self subclassResponsibility
]

{ #category : #initialization }
BPAssemblerInstruction >> initialize [
	super initialize.
	self assemblerInstructionForNewInstructions: self
]

{ #category : #factory }
BPAssemblerInstruction >> newData [
	"Creates a data object to be resolved later.
	 The aim of this factory is to set specific meta-data on the instruction depending
	 on the assembler instruction from which it is originated.
	"
	^ BPDataToResolve new
		assemblerInstruction: self assemblerInstructionForNewInstructions;
		yourself
]

{ #category : #factory }
BPAssemblerInstruction >> newInstruction [
	"Creates an instruction to be resolved later.
	 The aim of this factory is to set specific meta-data on the instruction depending
	 on the assembler instruction from which it is originated.
	"
	^ BPInstructionToResolve new
		assemblerInstruction: self assemblerInstructionForNewInstructions;
		yourself
]

{ #category : #accessing }
BPAssemblerInstruction >> tag [
	^ self className allButFirst: 'BP' size
]
