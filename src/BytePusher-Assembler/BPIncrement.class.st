"
Generates instructions that increment the value stored at an address.
"
Class {
	#name : #BPIncrement,
	#superclass : #BPAssemblerInstruction,
	#instVars : [
		'register'
	],
	#category : #'BytePusher-Assembler-Assembler'
}

{ #category : #generating }
BPIncrement >> generateFor: anAssembler [
	| instruction1 instruction2 |
	instruction1 := self newInstruction.
	instruction2 := self newInstruction.
	instruction1
		from: (self register forAssembler: anAssembler);
		to: (instruction2 asReference byteIndex: 2);
		jump: instruction2 asReference;
		beAddedTo: anAssembler.
	instruction2
		from: (anAssembler reservedMemoryZoneNamed: #INCREMENT_PAGE);
		to: (self register forAssembler: anAssembler);
		jump: BPNextInstructionReference new;
		beAddedTo: anAssembler
]

{ #category : #accessing }
BPIncrement >> register [
	^ register
]

{ #category : #accessing }
BPIncrement >> register: anObject [
	register := anObject
]
