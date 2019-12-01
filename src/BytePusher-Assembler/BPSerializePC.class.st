"
Generates an instruction that saves the address of aLabel in PC reserved memory zone.
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
	
	instruction1 := BPInstructionToResolve new
		from: (anAssembler reservedMemoryZoneNamed: #IDENTITY_PAGE) + labelAddress asDataAccess;
		to: (anAssembler reservedMemoryZoneNamed: #PROGRAM_COUNTER);
		tag: #serializePC:;
		yourself.
	instruction2 := BPInstructionToResolve new
		from: (anAssembler reservedMemoryZoneNamed: #IDENTITY_PAGE) + (labelAddress asDataAccess byteIndex: 1);
		to: (anAssembler reservedMemoryZoneNamed: #PROGRAM_COUNTER) + 1;
		tag: #serializePC:;
		yourself.
	instruction3 := BPInstructionToResolve new
		from: (anAssembler reservedMemoryZoneNamed: #IDENTITY_PAGE) + (labelAddress asDataAccess byteIndex: 2);
		to: (anAssembler reservedMemoryZoneNamed: #PROGRAM_COUNTER) + 2;
		tag: #serializePC:;
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
