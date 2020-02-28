"
I push some data on the data stack and update stack pointer (SP) accordingly.
"
Class {
	#name : #BPPushOnDataStack,
	#superclass : #BPAssemblerInstruction,
	#instVars : [
		'toPush'
	],
	#category : #'BytePusher-Assembler-Assembler'
}

{ #category : #generating }
BPPushOnDataStack >> generateFor: anAssembler [
	| instruction1 instruction2 |
	instruction1 := self newInstruction
							from: (anAssembler registerNamed: #SP);
							yourself.
	
	instruction2 := self newInstruction
							from: (self toPush forAssembler: anAssembler);
							to: (anAssembler reservedMemoryZoneNamed: #DATA_STACK)
							yourself.
							
	instruction1
		to: (instruction2 asReference byteIndex: 5);
		jump: instruction2 asReference;
		beAddedTo: anAssembler.
		
	instruction2
		jump: BPNextInstructionReference new;
		beAddedTo: anAssembler.
	
	"Increment stack pointer"
	anAssembler increment: #SP
]

{ #category : #accessing }
BPPushOnDataStack >> toPush [
	^ toPush
]

{ #category : #accessing }
BPPushOnDataStack >> toPush: anObject [
	toPush := anObject
]
