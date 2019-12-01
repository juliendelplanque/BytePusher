"
Let the instruction pointer do a unconditional jump to the defined address.

JMP address
"
Class {
	#name : #BPJump,
	#superclass : #BPAssemblerInstruction,
	#instVars : [
		'address'
	],
	#category : #'BytePusher-Assembler-Assembler'
}

{ #category : #accessing }
BPJump >> address [
	^ address
]

{ #category : #accessing }
BPJump >> address: anObject [
	address := anObject
]

{ #category : #generating }
BPJump >> generateFor: anAssembler [
	self newInstruction
		from: 0 asBPAddress;
		to: 0 asBPAddress;
		jump: (self address forAssembler: anAssembler);
		tag: #jump:;
		beAddedTo: anAssembler
]
