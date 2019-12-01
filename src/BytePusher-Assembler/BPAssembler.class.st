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
	#category : #'BytePusher-Assembler-Assembler'
}

{ #category : #accessing }
BPAssembler class >> defaultMemoryLayout [
	^ BPMemoryLayout standard
]

{ #category : #visiting }
BPAssembler >> acceptVisitor: aBPAssemblerVisitor [
	<generated>
	^ aBPAssemblerVisitor visitBPAssembler: self
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
	BPAdd new
		source: source;
		target: target;
		generateFor: self
]

{ #category : #adding }
BPAssembler >> addInstruction: anInstructionToResolve [
	self instructions add: anInstructionToResolve
]

{ #category : #assembling }
BPAssembler >> assemble [
	self setAddresses.
	self resolveNextInstructionReferences.
	self setLabelAddresses.
	self processAddressDataReference.
	^ self resolve
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
	BPCmp new
		x: x;
		y: y;
		generateFor: self
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
	BPJump new
		address: address;
		generateFor: self
]

{ #category : #instructions }
BPAssembler >> jumpIfNotEqual: address [
	"Let the instruction pointer do a jump to the defined address if ZERO flag is FALSE.

	 JNE address
	"
	BPJumpIfNotEqual new
		address: address;
		generateFor: self
]

{ #category : #labelling }
BPAssembler >> label: aSymbol [
	self addInstruction: (BPLabel label: aSymbol)
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
	BPMove new
		source: source;
		target: target;
		generateFor: self
]

{ #category : #instructions }
BPAssembler >> nop [
	"No-op instruction, does nothing.
	"
	self shouldBeImplemented
]

{ #category : #assembling }
BPAssembler >> processAddressDataReference [
	BPProcessAddressDataReference visit: self
]

{ #category : #accessing }
BPAssembler >> registerNamed: aSymbol [
	^ self memoryLayout registerNamed: aSymbol
]

{ #category : #accessing }
BPAssembler >> reservedMemoryZoneNamed: aSymbol [
	^ self memoryLayout reservedMemoryZoneNamed: aSymbol
]

{ #category : #assembling }
BPAssembler >> resolve [
	^ BPReferencesResolver visit: self
]

{ #category : #assembling }
BPAssembler >> resolveNextInstructionReferences [
	BPNextInstructionReferenceResolver visit: self
]

{ #category : #instructions }
BPAssembler >> serializePC: aSymbol [
	"Generates an instruction that saves the address of aLabel in PC reserved memory zone.
	 This is required to handle subroutines.
	"
	BPSerializePC new
		address: aSymbol;
		generateFor: self
]

{ #category : #assembling }
BPAssembler >> setAddresses [
	BPAddressesSetter visit: self
]

{ #category : #assembling }
BPAssembler >> setLabelAddresses [
	BPLabelAddressesSetter visit: self
]

{ #category : #instructions }
BPAssembler >> simpleAdd: source to: target [
	"Adds two numbers together and store result in source register.
	 This operations will NOT modify the carry and zero flag. 

	ADD reg, reg
	ADD reg, address
	ADD reg, constant
	"
	BPSimpleAdd new
		source: source;
		target: target;
		generateFor: self
	
]

{ #category : #instructions }
BPAssembler >> writePixel: pixelValue [
	"Writes #pixelValue on the pixel at the address pointed by 16bits address formed by A and B registers.
	 A register holds middle byte for address.
	 B register holds lower byte for address.
	"
	BPWritePixel new
		pixelValue: pixelValue;
		generateFor: self
]
