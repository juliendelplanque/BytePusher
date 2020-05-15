Class {
	#name : #BPStoreDataAtAddress,
	#superclass : #BPAssemblerInstruction,
	#instVars : [
		'source'
	],
	#category : #'BytePusher-Assembler-Assembler'
}

{ #category : #generating }
BPStoreDataAtAddress >> generateFor: anAssembler [
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
							from: (self source forAssembler: anAssembler);
							to: 0 asBPAddress; "Will be filled by previous instructions."
							jump: BPNextInstructionReference new;
							beAddedTo: anAssembler;
							yourself.
	
	instruction1
		to: (instruction4 asReference offset: 3);
		jump: instruction2 asReference.
	instruction2
		to: (instruction4 asReference offset: 4);
		jump: instruction3 asReference.
	instruction3
		to: (instruction4 asReference offset: 5);
		jump: instruction4 asReference.
]

{ #category : #accessing }
BPStoreDataAtAddress >> source [
	^ source
]

{ #category : #accessing }
BPStoreDataAtAddress >> source: anObject [
	source := anObject
]
