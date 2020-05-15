Class {
	#name : #BPReturn,
	#superclass : #BPAssemblerInstruction,
	#category : #'BytePusher-Assembler-Assembler'
}

{ #category : #generating }
BPReturn >> generateFor: anAssembler [
	| instruction1 |
	instruction1 := self newInstruction
							from: 0 asBPAddress;
							to: 0 asBPAddress;
							jump: 0 asBPAddress; "Will be filled by pop from the data stack."
							yourself.
							
	anAssembler popFromReturnStack: (instruction1 asReference offset: 8).
	anAssembler popFromReturnStack: (instruction1 asReference offset: 7).
	anAssembler popFromReturnStack: (instruction1 asReference offset: 6).
	
	instruction1 beAddedTo: anAssembler
]
