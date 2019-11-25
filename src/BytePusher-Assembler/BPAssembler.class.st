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
		jump: instruction2 asReference;
		tag: #add:to:.
	instruction2
		to: (instruction8 asReference byteIndex: 1);
		jump: instruction3 asReference;
		tag: #add:to:.
	instruction3
		to: (instruction9 asReference byteIndex: 1);
		jump: instruction4 asReference;
		tag: #add:to:.
	instruction4
		to: (instruction7 asReference byteIndex: 2);
		jump: instruction5 asReference;
		tag: #add:to:.
	instruction5
		to: (instruction8 asReference byteIndex: 2);
		jump: instruction6 asReference;
		tag: #add:to:.
	instruction6
		to: (instruction9 asReference byteIndex: 2);
		jump: instruction7 asReference;
		tag: #add:to:.
	instruction7
		jump: instruction8 asReference;
		tag: #add:to:.
	instruction8
		jump: instruction9 asReference;
		tag: #add:to:.
	instruction9 tag: #add:to:
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
		jump: inst2 asReference;
		tag: #cmp:with:.
	inst2
		to: (inst3 asReference byteIndex: 2);
		jump: inst3 asReference;
		tag: #cmp:with:.
	inst3 tag: #cmp:with:
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
		tag: #jump:;
		beAddedTo: self
]

{ #category : #instructions }
BPAssembler >> jumpIfNotEqual: address [
	"Let the instruction pointer do a jump to the defined address if ZERO flag is FALSE.

	 JNE address
	"
	| jmpAddress instruction1 instruction2 instruction3 instruction4 instruction5 instruction6 instruction7 |
	jmpAddress := address forAssembler: self.
	instruction1 := BPInstructionToResolve new
		from: jmpAddress asDataReference; "Copy byte 0 of jmpAddress"
		to: (self reservedMemoryZoneNamed: #JUMP_IF_ZERO) + (2 * ADDRESS_SIZE);
		beAddedTo: self
		yourself.
	instruction2 := BPInstructionToResolve new
		from: (jmpAddress asDataReference byteIndex: 1); "Copy byte 1 of jmpAddress"
		to: (self reservedMemoryZoneNamed: #JUMP_IF_ZERO) + (2 * ADDRESS_SIZE + 1);
		beAddedTo: self
		yourself.
	instruction3 := BPInstructionToResolve new
		from: (jmpAddress asDataReference byteIndex: 2); "Copy byte 2 of jmpAddress"
		to: (self reservedMemoryZoneNamed: #JUMP_IF_ZERO) + (2 * ADDRESS_SIZE + 2);
		beAddedTo: self
		yourself.
		
	instruction4 := BPInstructionToResolve new
		"Copy byte 0 of instruction generated after the ones generated by this method"
		from: (BPNextInstructionReference offset: 3) asDataReference;
		to: (self reservedMemoryZoneNamed: #JUMP_IF_NONZERO) + (2 * ADDRESS_SIZE);
		beAddedTo: self
		yourself.
	instruction5 := BPInstructionToResolve new
		"Copy byte 1 of instruction generated after the ones generated by this method"
		from: ((BPNextInstructionReference offset: 2) asDataReference byteIndex: 1);
		to: (self reservedMemoryZoneNamed: #JUMP_IF_NONZERO) + (2 * ADDRESS_SIZE + 1);
		beAddedTo: self
		yourself.
	instruction6 := BPInstructionToResolve new
		"Copy byte 2 of instruction generated after the ones generated by this method"
		from: ((BPNextInstructionReference offset: 1) asDataReference byteIndex: 2);
		to: (self reservedMemoryZoneNamed: #JUMP_IF_NONZERO) + (2 * ADDRESS_SIZE + 2);
		beAddedTo: self
		yourself.
	
	instruction7 := BPInstructionToResolve new
		from: (self registerNamed: #ZERO);
		yourself.
	instruction7
		to: (instruction7 asReference byteIndex: 8);
		"The lower-byte of this address will be overwritten by the instruction to point
		 to either #JUMP_IF_ZERO or #JUMP_IF_NONZERO.
		"
		jump: (self reservedMemoryZoneNamed: #JUMP_IF_ZERO);
		beAddedTo: self.
	instruction1
		jump: instruction2 asReference;
		tag: #jumpIfNotEqual:.
	instruction2
		jump: instruction3 asReference;
		tag: #jumpIfNotEqual:.
	instruction3
		jump: instruction4 asReference;
		tag: #jumpIfNotEqual:.
	instruction4
		jump: instruction5 asReference;
		tag: #jumpIfNotEqual:.
	instruction5
		jump: instruction6 asReference;
		tag: #jumpIfNotEqual:.
	instruction6
		jump: instruction7 asReference;
		tag: #jumpIfNotEqual:.
	instruction7
		tag: #jumpIfNotEqual:
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
	BPInstructionToResolve new
		from: (source forAssembler: self);
		to: (target forAssembler: self);
		jump: BPNextInstructionReference new;
		tag: #move:to:;
		beAddedTo: self
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
	| labelAddress instruction1 instruction2 instruction3 |
	labelAddress := aSymbol forAssembler: self.
	
	instruction1 := BPInstructionToResolve new
		from: (self reservedMemoryZoneNamed: #IDENTITY_PAGE) + labelAddress asDataAccess;
		to: (self reservedMemoryZoneNamed: #PROGRAM_COUNTER);
		tag: #serializePC:;
		yourself.
	instruction2 := BPInstructionToResolve new
		from: (self reservedMemoryZoneNamed: #IDENTITY_PAGE) + (labelAddress asDataAccess byteIndex: 1);
		to: (self reservedMemoryZoneNamed: #PROGRAM_COUNTER) + 1;
		tag: #serializePC:;
		yourself.
	instruction3 := BPInstructionToResolve new
		from: (self reservedMemoryZoneNamed: #IDENTITY_PAGE) + (labelAddress asDataAccess byteIndex: 2);
		to: (self reservedMemoryZoneNamed: #PROGRAM_COUNTER) + 2;
		tag: #serializePC:;
		yourself.
	instruction1
		beAddedTo: self;
		jump: instruction2 asReference.
	instruction2
		beAddedTo: self;
		jump: instruction3 asReference.
	instruction3
		beAddedTo: self;
		jump: BPNextInstructionReference new
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
	| sourceForAssembler targetForAssembler instruction1 instruction2 instruction3 |
	sourceForAssembler := source forAssembler: self.
	targetForAssembler := target forAssembler: self.
	"First, copy data at fromAddress to location of the add instructions."
	instruction1 := BPInstructionToResolve new
		from: sourceForAssembler;
		beAddedTo: self.
	"Second, copy data at toAddress to location of the add instructions."
	instruction2 := BPInstructionToResolve new
		from: targetForAssembler;
		beAddedTo: self.
	"Third, create the actual add instruction (beware the 16 least
	 significant bit of the #from address
	 will be set by the 2 previous instructions, so they it will be
	 overwritten at runtime whatever what is written on it).
	"
	instruction3 := BPInstructionToResolve new
		from: (self reservedMemoryZoneNamed: #ADD_PAGE);
		to: sourceForAssembler;
		beAddedTo: self.
	instruction1
		to: (instruction3 asReference byteIndex: 1);
		jump: instruction2 asReference;
		tag: #simpleAdd:to:.
	instruction2
		to: (instruction3 asReference byteIndex: 2);
		jump: instruction3 asReference;
		tag: #simpleAdd:to:.
	instruction3
		jump: BPNextInstructionReference new;
		tag: #simpleAdd:to:.
]

{ #category : #instructions }
BPAssembler >> writePixel: pixelValue [
	"Writes #pixelValue on the pixel at the address pointed by 16bits address formed by A and B registers.
	 A register holds middle byte for address.
	 B register holds lower byte for address.
	"
	| instruction1 instruction2 instruction3 |
	instruction1 := BPInstructionToResolve new
		tag: #writePixel:;
		from: (self registerNamed: #A);
		yourself.
	instruction2 := BPInstructionToResolve new
		tag: #writePixel:;
		from: (self registerNamed: #B);
		yourself.
	instruction3 := BPInstructionToResolve new
		tag: #writePixel:;
		from: (pixelValue forAssembler: self);
		to: (self reservedMemoryZoneNamed: #DISPLAY_FRAME) address;
		yourself.
	instruction1
		to: (instruction3 asReference byteIndex: 4);
		jump: instruction2 asReference;
		beAddedTo: self.
	instruction2
		to: (instruction3 asReference byteIndex: 5);
		jump: instruction3 asReference;
		beAddedTo: self.
	instruction3
		jump: BPNextInstructionReference new;
		beAddedTo: self.
]
