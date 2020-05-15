Class {
	#name : #BPPopFromStack,
	#superclass : #BPAssemblerInstruction,
	#instVars : [
		'destination'
	],
	#category : #'BytePusher-Assembler-Assembler'
}

{ #category : #accessing }
BPPopFromStack >> destination [
	^ destination
]

{ #category : #accessing }
BPPopFromStack >> destination: anObject [
	destination := anObject
]

{ #category : #generating }
BPPopFromStack >> generateFor: anAssembler [
	| instruction1 instruction2 |
	"Decrement stack pointer"
	anAssembler decrement: self stackPointerRegisterName.
	
	"Copy value at top of the stack to destination"
	instruction1 := self newInstruction
							from: (anAssembler registerNamed: self stackPointerRegisterName);
							yourself.
	
	instruction2 := self newInstruction
							from: (anAssembler reservedMemoryZoneNamed: self stackName);
							to: (self destination forAssembler: anAssembler)
							yourself.
							
	instruction1
		to: (instruction2 asReference offset: 2);
		jump: instruction2 asReference;
		beAddedTo: anAssembler.
		
	instruction2
		jump: BPNextInstructionReference new;
		beAddedTo: anAssembler
]

{ #category : #accessing }
BPPopFromStack >> stackName [
	"Return the name of the reserved memory zone storing the stack."
	^ self subclassResponsibility
]

{ #category : #accessing }
BPPopFromStack >> stackPointerRegisterName [
	"Return the name of the registerstoring the stack pointer."
	^ self subclassResponsibility
]
