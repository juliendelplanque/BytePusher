Class {
	#name : #BPAssembler,
	#superclass : #Object,
	#instVars : [
		'memoryLayout',
		'instructions'
	],
	#pools : [
		'BPConstants'
	],
	#category : #'BytePusher-Assembler'
}

{ #category : #accessing }
BPAssembler class >> defaultMemoryLayout [
	^ BPMemoryLayout standard
]

{ #category : #instructions }
BPAssembler >> add: source to: target [
	"Adds two numbers together and store result in source register.
	 This operations will modify the carry and zero flag. 
	 SP can be used as operand with ADD.

	ADD reg, reg
	ADD reg, address
	ADD reg, constant
	"
	self shouldBeImplemented
]

{ #category : #adding }
BPAssembler >> addInstruction: anInstructionToResolve [
	self instructions add: anInstructionToResolve
]

{ #category : #instructions }
BPAssembler >> cmp: x with: y [
	"Compares two values and sets the zero flag to true if they are equal.
	 SP can be used as operand with CMP.
	 Use this instruction before a conditional jump.

	CMP reg, reg
	CMP reg, address
	CMP reg, constant
	"
	self shouldBeImplemented
]

{ #category : #instructions }
BPAssembler >> db: constant [
	"Defines a variable. A variable can either be a single number, character or a string.

	DB constant
	"
	self shouldBeImplemented
]

{ #category : #accessing }
BPAssembler >> defaultMemoryLayout [
	^ self class defaultMemoryLayout
]

{ #category : #initialization }
BPAssembler >> initialize [
	super initialize.
	self memoryLayout: self defaultMemoryLayout.
	self instructions: OrderedCollection new.
]

{ #category : #accessing }
BPAssembler >> instructions [
	^ instructions
]

{ #category : #accessing }
BPAssembler >> instructions: anObject [
	instructions := anObject
]

{ #category : #instructions }
BPAssembler >> jump: address [
	"Let the instruction pointer do a unconditional jump to the defined address.

	 JMP address
	"
	BPInstructionToResolve from: 0 asBPAddress to: 0 asBPAddress jump: address
]

{ #category : #instructions }
BPAssembler >> jumpIfNotEqual: address [
	"Let the instruction pointer do a jump to the defined address if ZERO flag is FALSE.

	 JNE address
	"
	self shouldBeImplemented
]

{ #category : #labelling }
BPAssembler >> label: aSymbol [
	self shouldBeImplemented
]

{ #category : #accessing }
BPAssembler >> memoryLayout [
	^ memoryLayout
]

{ #category : #accessing }
BPAssembler >> memoryLayout: anObject [
	memoryLayout := anObject
]

{ #category : #instructions }
BPAssembler >> move: source to: target [
	"Copies a value from src to dest.
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
	BPInstructionToResolve
		from: source
		to: target
		jump: BPNextInstructionReference new
]

{ #category : #instructions }
BPAssembler >> nop [
	"No-op instruction, does nothing.
	"
	self shouldBeImplemented
]

{ #category : #instructions }
BPAssembler >> serializePC: aLabel [
	"Generates an instruction that saves the address of aLabel in PC reserved memory zone.
	 This is required to handle subroutines.
	"
	self shouldBeImplemented
]

{ #category : #instructions }
BPAssembler >> writePixel: pixel [
	"Writes #pixelValue on the pixel at the address pointed by 16bits address formed by A and B registers.
	 A register holds middle byte for address.
	 B register holds lower byte for address.
	"
	self shouldBeImplemented
]
