Class {
	#name : #BPFetchDataAtAddress,
	#superclass : #BPAssemblerInstruction,
	#instVars : [
		'destination'
	],
	#category : #'BytePusher-Assembler-Assembler'
}

{ #category : #accessing }
BPFetchDataAtAddress >> destination [
	^ destination
]

{ #category : #accessing }
BPFetchDataAtAddress >> destination: anObject [
	destination := anObject
]

{ #category : #generating }
BPFetchDataAtAddress >> generateFor: anAssembler [
	|instruction1 instruction2 instruction3 instruction4|
	instruction1 := self newInstruction
							from: (anAssembler registerNamed: #A);
							beAddedTo: anAssembler
							yourself.
							
	instruction2 := self newInstruction
							from: (anAssembler registerNamed: #B);
							beAddedTo: anAssembler
							yourself.
	
	instruction3 := self newInstruction
							from: (anAssembler registerNamed: #C);
							beAddedTo: anAssembler
							yourself.
							
	instruction4 := self newInstruction
							from: 0 asBPAddress; "Will be filled by previous instructions."
							to: (self destination forAssembler: anAssembler);
							jump: BPNextInstructionReference new;
							beAddedTo: anAssembler;
							yourself.
	
	instruction1
		to: (instruction2 asReference byteIndex: 0);
		jump: instruction2 asReference.
	instruction2
		to: (instruction2 asReference byteIndex: 1);
		jump: instruction3 asReference.
	instruction3
		to: (instruction2 asReference byteIndex: 2);
		jump: instruction4 asReference.
]
