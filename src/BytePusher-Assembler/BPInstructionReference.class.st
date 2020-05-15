Class {
	#name : #BPInstructionReference,
	#superclass : #BPAbstractInstructionReference,
	#instVars : [
		'instruction'
	],
	#category : #'BytePusher-Assembler-Model'
}

{ #category : #'instance creation' }
BPInstructionReference class >> instruction: instruction [
	^ self new
		instruction: instruction;
		yourself
]

{ #category : #'instance creation' }
BPInstructionReference class >> instruction: instruction byteIndex: byteIndex [
	^ self new
		instruction: instruction;
		offset: byteIndex;
		yourself
]

{ #category : #visiting }
BPInstructionReference >> acceptVisitor: aBPAssemblerVisitor [
	<generated>
	^ aBPAssemblerVisitor visitBPReferenceToInstruction: self
]

{ #category : #accessing }
BPInstructionReference >> address [
	^ self instruction address
]

{ #category : #'assembler-dispatch' }
BPInstructionReference >> forAssembler: aBPAssembler [ 
	^ self
]

{ #category : #accessing }
BPInstructionReference >> instruction [
	^ instruction
]

{ #category : #accessing }
BPInstructionReference >> instruction: anObject [
	instruction := anObject
]
