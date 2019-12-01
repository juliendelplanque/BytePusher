"
Copies a value from src to dest.
The MOV instruction is the only one able to directly modify the memory.
SP can be used as operand with MOV.

MOV <target> <source>
======================
MOV reg, reg
MOV reg, address
MOV reg, constant
MOV address, reg
MOV address, constant
"
Class {
	#name : #BPMove,
	#superclass : #BPAssemblerInstruction,
	#instVars : [
		'source',
		'target'
	],
	#category : #'BytePusher-Assembler-Assembler'
}

{ #category : #generating }
BPMove >> generateFor: anAssembler [
	self newInstruction
		from: (self source forAssembler: anAssembler);
		to: (self target forAssembler: anAssembler);
		jump: BPNextInstructionReference new;
		beAddedTo: anAssembler
]

{ #category : #accessing }
BPMove >> source [
	^ source
]

{ #category : #accessing }
BPMove >> source: anObject [
	source := anObject
]

{ #category : #accessing }
BPMove >> target [
	^ target
]

{ #category : #accessing }
BPMove >> target: anObject [
	target := anObject
]
