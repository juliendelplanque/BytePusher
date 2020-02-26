"
Generates instructions that decrement the value stored at an address.
"
Class {
	#name : #BPDecrement,
	#superclass : #BPAssemblerInstruction,
	#instVars : [
		'register'
	],
	#category : #'BytePusher-Assembler-Assembler'
}

{ #category : #generating }
BPDecrement >> generateFor: anAssembler [
	| instruction1 instruction2 |
	instruction1 := self newInstruction.
	instruction2 := self newInstruction.
	instruction1
		from: (self register forAssembler: anAssembler);
		to: (instruction2 asReference byteIndex: 2);
		jump: instruction2 asReference;
		beAddedTo: anAssembler.
	instruction2
		from: (anAssembler reservedMemoryZoneNamed: #DECREMENT_PAGE);
		to: (self register forAssembler: anAssembler);
		jump: BPNextInstructionReference new;
		beAddedTo: anAssembler
]

{ #category : #accessing }
BPDecrement >> register [
	^ register
]

{ #category : #accessing }
BPDecrement >> register: anObject [
	register := anObject
]
