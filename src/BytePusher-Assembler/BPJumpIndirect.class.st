Class {
	#name : #BPJumpIndirect,
	#superclass : #BPAssemblerInstruction,
	#instVars : [
		'address'
	],
	#category : #'BytePusher-Assembler-Assembler'
}

{ #category : #accessing }
BPJumpIndirect >> address [
	^ address
]

{ #category : #accessing }
BPJumpIndirect >> address: anObject [
	address := anObject
]

{ #category : #generating }
BPJumpIndirect >> generateFor: anAssembler [
	| instruction1 instruction4 instruction2 instruction3 |
	instruction1 := self newInstruction.
	instruction2 := self newInstruction.
	instruction3 := self newInstruction.
	instruction4 := self newInstruction.
	
	instruction1
		from: (self address forAssembler: anAssembler);
		to: instruction4 asReference jumpAddressHighByte;
		jump: instruction2;
		beAddedTo: anAssembler.
		
	instruction2
		from: (self address forAssembler: anAssembler) + 1;
		to: instruction4 asReference jumpAddressMiddleByte;
		jump: instruction3;
		beAddedTo: anAssembler.
		
	instruction3
		from: (self address forAssembler: anAssembler) + 2;
		to: instruction4 asReference jumpAddressLowByte;
		jump: instruction4;
		beAddedTo: anAssembler.

	instruction4
		from: 0 asBPAddress;
		to: 0 asBPAddress;
		jump: 0 asBPAddress;
		beAddedTo: anAssembler
]
