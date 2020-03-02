Class {
	#name : #BPPushOnStack,
	#superclass : #BPAssemblerInstruction,
	#instVars : [
		'toPush'
	],
	#category : #'BytePusher-Assembler-Assembler'
}

{ #category : #generating }
BPPushOnStack >> generateFor: anAssembler [
	| instruction1 instruction2 |
	instruction1 := self newInstruction
							from: (anAssembler registerNamed: self stackPointerRegisterName);
							yourself.
	
	instruction2 := self newInstruction
							from: (self toPush forAssembler: anAssembler);
							to: (anAssembler reservedMemoryZoneNamed: self stackName);
							yourself.
							
	instruction1
		to: (instruction2 asReference byteIndex: 5);
		jump: instruction2 asReference;
		beAddedTo: anAssembler.
		
	instruction2
		jump: BPNextInstructionReference new;
		beAddedTo: anAssembler.
	
	"Increment stack pointer"
	anAssembler increment: self stackPointerRegisterName
]

{ #category : #accessing }
BPPushOnStack >> stackName [
	"Return the name of the reserved memory zone storing the stack."
	^ self subclassResponsibility
]

{ #category : #accessing }
BPPushOnStack >> stackPointerRegisterName [
	"Return the name of the registerstoring the stack pointer."
	^ self subclassResponsibility
]

{ #category : #accessing }
BPPushOnStack >> toPush [
	^ toPush
]

{ #category : #accessing }
BPPushOnStack >> toPush: anObject [
	toPush := anObject
]
