"
The no-operation instruction. Does nothing.
Implemented by copying the value at an address to itself.
"
Class {
	#name : #BPNop,
	#superclass : #BPAssemblerInstruction,
	#category : #'BytePusher-Assembler-Assembler'
}

{ #category : #generating }
BPNop >> generateFor: anAssembler [
	self newInstruction
		from: (anAssembler reservedMemoryZoneNamed: #RESERVED_BLANK) address;
		to: (anAssembler reservedMemoryZoneNamed: #RESERVED_BLANK) address;
		beAddedTo: anAssembler;
		jump: BPNextInstructionReference new
]