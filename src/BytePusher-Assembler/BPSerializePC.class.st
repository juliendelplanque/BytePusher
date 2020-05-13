"
Generates instructions that saves the address of aLabel in PC reserved memory zone.
"
Class {
	#name : #BPSerializePC,
	#superclass : #BPAssemblerInstruction,
	#instVars : [
		'address'
	],
	#category : #'BytePusher-Assembler-Assembler'
}

{ #category : #accessing }
BPSerializePC >> address [
	^ address
]

{ #category : #accessing }
BPSerializePC >> address: anObject [
	address := anObject
]

{ #category : #generating }
BPSerializePC >> generateFor: anAssembler [
	| labelAddress instruction1 instruction2 instruction3 |
	labelAddress := self address forAssembler: anAssembler.
	
	instruction1 := self newInstruction
		from: (anAssembler reservedMemoryZoneNamed: #IDENTITY_PAGE) + labelAddress asAddressReference;
		to: (anAssembler reservedMemoryZoneNamed: #PROGRAM_COUNTER);
		yourself.
	instruction2 := self newInstruction
		from: (anAssembler reservedMemoryZoneNamed: #IDENTITY_PAGE) + (labelAddress asAddressReference byteIndex: 1);
		to: (anAssembler reservedMemoryZoneNamed: #PROGRAM_COUNTER) + 1;
		yourself.
	instruction3 := self newInstruction
		from: (anAssembler reservedMemoryZoneNamed: #IDENTITY_PAGE) + (labelAddress asAddressReference byteIndex: 2);
		to: (anAssembler reservedMemoryZoneNamed: #PROGRAM_COUNTER) + 2;
		yourself.
	instruction1
		beAddedTo: anAssembler;
		jump: instruction2 asReference.
	instruction2
		beAddedTo: anAssembler;
		jump: instruction3 asReference.
	instruction3
		beAddedTo: anAssembler;
		jump: BPNextInstructionReference new
]
