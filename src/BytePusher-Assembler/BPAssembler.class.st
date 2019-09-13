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
	| sourceForAssembler targetForAssembler instruction1 instruction2 instruction3 instruction4 instruction5 instruction6 instruction7 instruction8 instruction9 |
	sourceForAssembler := source forAssembler: self.
	targetForAssembler := target forAssembler: self.
	"First, copy data at fromAddress to location of the add, carry and zero instructions."
	instruction1 := BPInstructionToResolve new
		from: sourceForAssembler;
		beAddedTo: self.
	instruction2 := BPInstructionToResolve new
		from: sourceForAssembler;
		beAddedTo: self.
	instruction3 := BPInstructionToResolve new
		from: sourceForAssembler;
		beAddedTo: self.
	"Second, copy data at toAddress to location of the add, carry and zero instructions."
	instruction4 := BPInstructionToResolve new
		from: targetForAssembler;
		beAddedTo: self.
	instruction5 := BPInstructionToResolve new
		from: targetForAssembler;
		beAddedTo: self.
	instruction6 := BPInstructionToResolve new
		from: targetForAssembler;
		beAddedTo: self.
	"Third, create the actual add instruction (beware the 16 least
	 significant bit of the #from address
	 will be set by the 2 previous instructions, so they it will be
	 overwritten at runtime whatever what is written on it).
	"
	instruction7 := BPInstructionToResolve new
		from: (self reservedMemoryZoneNamed: #ADD_PAGE);
		to: sourceForAssembler;
		beAddedTo: self.
	"Fourth, create the actual carry flag instruction (beware the 16 least
	 significant bit of the #from address
	 will be set by the 2 previous instructions, so they it will be
	 overwritten at runtime whatever what is written on it).
	"
	instruction8 := BPInstructionToResolve new
		from: (self reservedMemoryZoneNamed: #ADD_CARY_FLAG_PAGE);
		to: (self registerNamed: #CARRY);
		beAddedTo: self.
	"Third, create the actual zero flag instruction (beware the 16 least
	 significant bit of the #from address
	 will be set by the 2 previous instructions, so they it will be
	 overwritten at runtime whatever what is written on it).
	"
	instruction9 := BPInstructionToResolve new
		from: (self reservedMemoryZoneNamed: #ADD_ZERO_FLAG_PAGE);
		to: (self registerNamed: #ZERO);
		jump: BPNextInstructionReference new;
		beAddedTo: self.
	instruction1
		to: (instruction7 asReference byteIndex: 1);
		jump: instruction2 asReference.
	instruction2
		to: (instruction8 asReference byteIndex: 1);
		jump: instruction3 asReference.
	instruction3
		to: (instruction9 asReference byteIndex: 1);
		jump: instruction4 asReference.
	instruction4
		to: (instruction7 asReference byteIndex: 2);
		jump: instruction5 asReference.
	instruction5
		to: (instruction8 asReference byteIndex: 2);
		jump: instruction6 asReference.
	instruction6
		to: (instruction9 asReference byteIndex: 2);
		jump: instruction7 asReference.
	instruction7
		jump: instruction8 asReference.
	instruction8
		jump: instruction9 asReference.
]

{ #category : #adding }
BPAssembler >> addInstruction: anInstructionToResolve [
	self instructions add: anInstructionToResolve
]

{ #category : #assembling }
BPAssembler >> assemble [
	self setAddresses.
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

	| inst1 inst2 inst3 |
	inst1 := BPInstructionToResolve new
		from: (x forAssembler: self);
		beAddedTo: self.
	inst2 := BPInstructionToResolve new
		from: (y forAssembler: self);
		beAddedTo: self.
	inst3 := BPInstructionToResolve new
		from: (self reservedMemoryZoneNamed: #CMP_PAGE) address;
		to: (self registerNamed: #ZERO) address;
		jump: BPNextInstructionReference new;
		beAddedTo: self.
		
	inst1
		to: (inst3 asReference byteIndex: 1);
		jump: inst2 asReference.
	inst2
		to: (inst3 asReference byteIndex: 2);
		jump: inst3 asReference
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
	(BPInstructionToResolve from: 0 asBPAddress to: 0 asBPAddress jump: (address forAssembler: self))
		beAddedTo: self
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
	BPInstructionToResolve new
		from: (source forAssembler: self);
		to: (target forAssembler: self);
		jump: BPNextInstructionReference new;
		beAddedTo: self
]

{ #category : #instructions }
BPAssembler >> nop [
	"No-op instruction, does nothing.
	"
	self shouldBeImplemented
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

{ #category : #instructions }
BPAssembler >> serializePC: aLabel [
	"Generates an instruction that saves the address of aLabel in PC reserved memory zone.
	 This is required to handle subroutines.
	"
	self shouldBeImplemented
]

{ #category : #assembling }
BPAssembler >> setAddresses [
	BPAddressesSetter visit: self
]

{ #category : #instructions }
BPAssembler >> writePixel: pixel [
	"Writes #pixelValue on the pixel at the address pointed by 16bits address formed by A and B registers.
	 A register holds middle byte for address.
	 B register holds lower byte for address.
	"
	self shouldBeImplemented
]
