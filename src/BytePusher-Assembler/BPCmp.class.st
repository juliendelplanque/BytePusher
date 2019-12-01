"
Compares two values and sets the zero flag to true if they are equal.
SP can be used as operand with CMP.
Use this instruction before a conditional jump.

CMP reg, reg
CMP reg, address
CMP reg, constant
"
Class {
	#name : #BPCmp,
	#superclass : #BPAssemblerInstruction,
	#instVars : [
		'x',
		'y'
	],
	#category : #'BytePusher-Assembler-Assembler'
}

{ #category : #generating }
BPCmp >> generateFor: anAssembler [
	| inst1 inst2 inst3 |
	inst1 := self newInstruction
		from: (self x forAssembler: anAssembler);
		beAddedTo: anAssembler.
	inst2 := self newInstruction
		from: (self y forAssembler: anAssembler);
		beAddedTo: anAssembler.
	inst3 := self newInstruction
		from: (anAssembler reservedMemoryZoneNamed: #CMP_PAGE) address;
		to: (anAssembler registerNamed: #ZERO) address;
		jump: BPNextInstructionReference new;
		beAddedTo: anAssembler.
		
	inst1
		to: (inst3 asReference byteIndex: 1);
		jump: inst2 asReference;
		tag: #cmp:with:.
	inst2
		to: (inst3 asReference byteIndex: 2);
		jump: inst3 asReference;
		tag: #cmp:with:.
	inst3 tag: #cmp:with:
]

{ #category : #accessing }
BPCmp >> x [
	^ x
]

{ #category : #accessing }
BPCmp >> x: anObject [
	x := anObject
]

{ #category : #accessing }
BPCmp >> y [
	^ y
]

{ #category : #accessing }
BPCmp >> y: anObject [
	y := anObject
]
