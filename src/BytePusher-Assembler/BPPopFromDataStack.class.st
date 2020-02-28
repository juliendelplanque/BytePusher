"
I pop data at top of the the data stack, move it to destionation and update stack pointer (SP) accordingly.
"
Class {
	#name : #BPPopFromDataStack,
	#superclass : #BPAssemblerInstruction,
	#instVars : [
		'destination'
	],
	#category : #'BytePusher-Assembler-Assembler'
}

{ #category : #accessing }
BPPopFromDataStack >> destination [
	^ destination
]

{ #category : #accessing }
BPPopFromDataStack >> destination: anObject [
	destination := anObject
]

{ #category : #generating }
BPPopFromDataStack >> generateFor: anAssembler [
	| instruction1 instruction2 |
	"Decrement stack pointer"
	anAssembler decrement: #SP.
	
	"Copy value at top of the stack to destination"
	instruction1 := self newInstruction
							from: (anAssembler registerNamed: #SP);
							yourself.
	
	instruction2 := self newInstruction
							from: (anAssembler reservedMemoryZoneNamed: #DATA_STACK);
							to: (self destination forAssembler: anAssembler)
							yourself.
							
	instruction1
		to: (instruction2 asReference byteIndex: 2);
		jump: instruction2 asReference;
		beAddedTo: anAssembler.
		
	instruction2
		jump: BPNextInstructionReference new;
		beAddedTo: anAssembler
]
