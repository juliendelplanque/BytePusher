Class {
	#name : #BPAssembly,
	#superclass : #Object,
	#instVars : [
		'registers',
		'reservedMemoryZones',
		'memory',
		'labels',
		'addressOfNextInstructionToGenerate',
		'referencesToFutureMemory'
	],
	#pools : [
		'BPConstants'
	],
	#category : #'BytePusher-Assembly'
}

{ #category : #instructions }
BPAssembly >> add: source to: target [
	"Adds two numbers together and store result in source register.
	 This operations will modify the carry and zero flag. 
	 SP can be used as operand with ADD.

	ADD reg, reg
	ADD reg, address
	ADD reg, constant
	"
	| fromAddress toAddress |
	fromAddress := source forAssembly: self.
	toAddress := target forAssembly: self.
	"First, copy data at fromAddress to location of the add, carry and zero instructions."
	(BPInstruction
		from: fromAddress
		to: addressOfNextInstructionToGenerate + 55
		jump: addressOfNextInstructionToGenerate + INSTRUCTION_SIZE) writeOn: self at: addressOfNextInstructionToGenerate memoryAddress.
	(BPInstruction
		from: fromAddress
		to: addressOfNextInstructionToGenerate + 64
		jump: addressOfNextInstructionToGenerate + (2*INSTRUCTION_SIZE)) writeOn: self at: addressOfNextInstructionToGenerate memoryAddress + INSTRUCTION_SIZE.
	(BPInstruction
		from: fromAddress
		to: addressOfNextInstructionToGenerate + 73
		jump: addressOfNextInstructionToGenerate + (3*INSTRUCTION_SIZE)) writeOn: self at: addressOfNextInstructionToGenerate memoryAddress + (2*INSTRUCTION_SIZE).
	"Second, copy data at toAddress to location of the add, carry and zero instructions."
	(BPInstruction
		from: toAddress
		to: addressOfNextInstructionToGenerate + 56
		jump: addressOfNextInstructionToGenerate + (4*INSTRUCTION_SIZE)) writeOn: self at: addressOfNextInstructionToGenerate memoryAddress + (3*INSTRUCTION_SIZE).
	(BPInstruction
		from: toAddress
		to: addressOfNextInstructionToGenerate + 65
		jump: addressOfNextInstructionToGenerate + (5*INSTRUCTION_SIZE)) writeOn: self at: addressOfNextInstructionToGenerate memoryAddress + (4*INSTRUCTION_SIZE).
	(BPInstruction
		from: toAddress
		to: addressOfNextInstructionToGenerate + 74
		jump: addressOfNextInstructionToGenerate + (6*INSTRUCTION_SIZE)) writeOn: self at: addressOfNextInstructionToGenerate memoryAddress + (5*INSTRUCTION_SIZE).
	"Third, create the actual add instruction (beware the 16 least
	 significant bit of the #from address
	 will be set by the 2 previous instructions, so they it will be
	 overwritten at runtime whatever what is written on it).
	"
	(BPInstruction
		from: BPAddPageBuilder startAddress
		to: fromAddress
		jump: addressOfNextInstructionToGenerate + (7*INSTRUCTION_SIZE)) writeOn: self at: addressOfNextInstructionToGenerate memoryAddress + (6*INSTRUCTION_SIZE).
	"Fourth, create the actual carry flag instruction (beware the 16 least
	 significant bit of the #from address
	 will be set by the 2 previous instructions, so they it will be
	 overwritten at runtime whatever what is written on it).
	"
	(BPInstruction
		from: BPAddCarryFlagPageBuilder startAddress
		to: (self registerNamed: #CARRY)
		jump: addressOfNextInstructionToGenerate + (8*INSTRUCTION_SIZE)) writeOn: self at: addressOfNextInstructionToGenerate memoryAddress + (7*INSTRUCTION_SIZE).
	"Third, create the actual zero flag instruction (beware the 16 least
	 significant bit of the #from address
	 will be set by the 2 previous instructions, so they it will be
	 overwritten at runtime whatever what is written on it).
	"
	(BPInstruction
		from: BPAddZeroFlagPageBuilder startAddress
		to: (self registerNamed: #ZERO)
		jump: addressOfNextInstructionToGenerate + (9*INSTRUCTION_SIZE)) writeOn: self at: addressOfNextInstructionToGenerate memoryAddress + (8*INSTRUCTION_SIZE).
	self incrementAddressOfNextInstructionToGenerate: (9*INSTRUCTION_SIZE).
	self addReferenceToFutureMemory: addressOfNextInstructionToGenerate - ADDRESS_SIZE
]

{ #category : #adding }
BPAssembly >> addLabel: aBPLabel [
	(registers noneSatisfy: [ :r | r name = aBPLabel label ])
		ifFalse: [ self error: 'A register is already named ' , aBPLabel label ].
		
	(labels noneSatisfy: [ :l | l label = aBPLabel label ])
		ifFalse: [ self error: 'A label is already named ' , aBPLabel label ].
		
	labels add: aBPLabel
]

{ #category : #initialization }
BPAssembly >> addReferenceToFutureMemory: anAddress [
	referencesToFutureMemory add: anAddress
]

{ #category : #accessing }
BPAssembly >> addressOfNextInstructionToGenerate [
	^ addressOfNextInstructionToGenerate
]

{ #category : #accessing }
BPAssembly >> addressOfNextInstructionToGenerate: anObject [
	addressOfNextInstructionToGenerate := anObject
]

{ #category : #instructions }
BPAssembly >> cmp: x with: y [
	"Compares two values and sets the zero flag to true if they are equal.
	 SP can be used as operand with CMP.
	 Use this instruction before a conditional jump.

	CMP reg, reg
	CMP reg, address
	CMP reg, constant
	"
	| xAddress yAddress |
	xAddress := x forAssembly: self.
	yAddress := y forAssembly: self.
	(BPInstruction
		from: xAddress
		to: addressOfNextInstructionToGenerate + (2 * INSTRUCTION_SIZE) + 1
		jump: addressOfNextInstructionToGenerate + INSTRUCTION_SIZE) writeOn: self at: addressOfNextInstructionToGenerate memoryAddress.
	(BPInstruction
		from: yAddress
		to: addressOfNextInstructionToGenerate + (2 * INSTRUCTION_SIZE) + 2
		jump: addressOfNextInstructionToGenerate + (2*INSTRUCTION_SIZE)) writeOn: self at: (addressOfNextInstructionToGenerate + INSTRUCTION_SIZE) memoryAddress.
	(BPInstruction
		from: BPCmpPageBuilder startAddress
		to: (self registerNamed: #ZERO)
		jump: addressOfNextInstructionToGenerate + (3*INSTRUCTION_SIZE)) writeOn: self at: (addressOfNextInstructionToGenerate + (2*INSTRUCTION_SIZE)) memoryAddress.
	self incrementAddressOfNextInstructionToGenerate: (3*INSTRUCTION_SIZE).
	self addReferenceToFutureMemory: addressOfNextInstructionToGenerate - ADDRESS_SIZE
]

{ #category : #instructions }
BPAssembly >> db: constant [
	"Defines a variable. A variable can either be a single number, character or a string.

	DB constant
	"
	self shouldBeImplemented
]

{ #category : #'as yet unclassified' }
BPAssembly >> incrementAddressOfNextInstructionToGenerate: anInteger [
	addressOfNextInstructionToGenerate := addressOfNextInstructionToGenerate + anInteger.
	referencesToFutureMemory := referencesToFutureMemory reject: [ :addr |
		(addr accessInteger: self memory) asBPAddress < addressOfNextInstructionToGenerate ].
]

{ #category : #'as yet unclassified' }
BPAssembly >> incrementReferencesToFutureMemory: anInteger [
	referencesToFutureMemory := referencesToFutureMemory do: [ :addr |
		((addr accessInteger: self memory) asBPAddress + anInteger)
			writeOn: self memory at: addr memoryAddress ]
]

{ #category : #initialization }
BPAssembly >> initialize [
	super initialize.
	registers := { 
		BPRegister name: #PC address: PROGRAM_COUNTER_ADDRESS.
		BPRegister name: #A address: USER_MEMORY_ADDRESS.
		BPRegister name: #B address: USER_MEMORY_ADDRESS + 1.
		BPRegister name: #C address: USER_MEMORY_ADDRESS + 2.
		BPRegister name: #D address: USER_MEMORY_ADDRESS + 3.
		BPRegister name: #SP address: USER_MEMORY_ADDRESS + 4.
		BPRegister name: #CARRY address: USER_MEMORY_ADDRESS + 5.
		BPRegister name: #ZERO address: USER_MEMORY_ADDRESS + 6 }.
	reservedMemoryZones := { 
		BPReservedMemoryZone name: #JUMP_IF_ZERO startAddress: USER_MEMORY_ADDRESS + 7 size: INSTRUCTION_SIZE.
		BPReservedMemoryZone name: #JUMP_IF_NONZERO startAddress: USER_MEMORY_ADDRESS + 7 + INSTRUCTION_SIZE size: INSTRUCTION_SIZE.
		BPReservedMemoryZone name: #DISPLAY_FRAME startAddress: 16rFE0000 size: PIXELS_COUNT.
		BPReservedMemoryZone name: #AUDIO_SAMPLE startAddress: USER_MEMORY_ADDRESS + 7 + (2 * INSTRUCTION_SIZE) + PIXELS_COUNT size: AUDIO_SAMPLE_SIZE.
	}.
		
	addressOfNextInstructionToGenerate := ((registers , (reservedMemoryZones reject: [ :x | x name = #DISPLAY_FRAME ])) detectMax: #address) address + 1.
	self serializeAddressOfNextInstructionToGenerate.
	
	PIXEL_POINTER_ADDRESS asBPAddress store: (self reservedMemoryZoneNamed: #DISPLAY_FRAME) address higherByte in: self memory.
	AUDIO_POINTER_ADDRESS asBPAddress store: (self reservedMemoryZoneNamed: #AUDIO_SAMPLE) address middleByte in: self memory.
	AUDIO_POINTER_ADDRESS asBPAddress + 1 store: (self reservedMemoryZoneNamed: #AUDIO_SAMPLE) address lowerByte in: self memory.
	
	labels := OrderedCollection new.
	self resetReferencesToFutureMemory.
	self addReferenceToFutureMemory: PROGRAM_COUNTER_ADDRESS asBPAddress
]

{ #category : #initialization }
BPAssembly >> initializeMemory [
	memory := ByteArray new: MEMORY_SIZE.
	BPAddPageBuilder writeBankOn: memory.
	BPAddCarryFlagPageBuilder writeBankOn: memory.
	BPAddZeroFlagPageBuilder writeBankOn: memory.
	BPCmpPageBuilder writeBankOn: memory.
	BPIdentityPageBuilder writeBankOn: memory.
	^ memory
]

{ #category : #instructions }
BPAssembly >> jump: address [
	"Let the instruction pointer do a unconditional jump to the defined address.

	 JMP address
	"
	| jmpAddress |
	jmpAddress := address forAssembly: self.
	(BPInstruction
		from: 0
		to: 0
		jump: jmpAddress) writeOn: self at: addressOfNextInstructionToGenerate memoryAddress.
	self incrementAddressOfNextInstructionToGenerate: INSTRUCTION_SIZE.
]

{ #category : #instructions }
BPAssembly >> jumpIfNotEqual: address [
	"Let the instruction pointer do a jump to the defined address if ZERO flag is FALSE.

	 JNE address
	"
	| jmpAddress addressForNotEqual addressForEqual |
	jmpAddress := address forAssembly: self.
	
	addressForNotEqual := (addressOfNextInstructionToGenerate
									+ INSTRUCTION_SIZE
									+ 16r100
									>> 8
									<< 8) asBPAddress.
	addressForEqual := addressForNotEqual + INSTRUCTION_SIZE.
	
	(BPInstruction
		from: (self registerNamed: #ZERO)
		to: addressOfNextInstructionToGenerate + 8
		jump: addressForNotEqual >> 8 << 8) writeOn: self at: addressOfNextInstructionToGenerate memoryAddress.
	
	addressOfNextInstructionToGenerate := addressForNotEqual.
	(BPInstruction
		from: 0
		to: 0
		jump: jmpAddress) writeOn: self at: addressOfNextInstructionToGenerate memoryAddress.
		
	addressOfNextInstructionToGenerate := addressForEqual.
	(BPInstruction
		from: 0
		to: 0
		jump: addressOfNextInstructionToGenerate + INSTRUCTION_SIZE) writeOn: self at: addressOfNextInstructionToGenerate memoryAddress.
	self incrementAddressOfNextInstructionToGenerate: INSTRUCTION_SIZE.
	self addReferenceToFutureMemory: addressOfNextInstructionToGenerate - ADDRESS_SIZE
]

{ #category : #labelling }
BPAssembly >> label: aSymbol [
	self addLabel: (BPLabel label: aSymbol address: addressOfNextInstructionToGenerate)
]

{ #category : #accessing }
BPAssembly >> labelNamed: aSymbol [
	^ labels detect: [ :label | label label = aSymbol ]
]

{ #category : #accessing }
BPAssembly >> labels [
	^ labels
]

{ #category : #accessing }
BPAssembly >> memory [
	^ memory ifNil: [ self initializeMemory ]
]

{ #category : #accessing }
BPAssembly >> memory: anObject [
	memory := anObject
]

{ #category : #accessing }
BPAssembly >> memoryAt: anInteger [
	"Access the memory with index starting at 0 and finishing at self memory size - 1."
	^ self memory at: anInteger + 1
]

{ #category : #accessing }
BPAssembly >> memoryAt: anInteger put: aByte [
	"Set the memory with index starting at 0 and finishing at self memory size - 1."
	^ self memory at: anInteger + 1 put: aByte
]

{ #category : #instructions }
BPAssembly >> move: source to: target [
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
	| fromAddress toAddress |
	fromAddress := source forAssembly: self.
	toAddress := target forAssembly: self.
	(BPInstruction
		from: fromAddress
		to: toAddress
		jump: addressOfNextInstructionToGenerate + INSTRUCTION_SIZE) writeOn: self at: addressOfNextInstructionToGenerate memoryAddress.
	self incrementAddressOfNextInstructionToGenerate: INSTRUCTION_SIZE.
	self addReferenceToFutureMemory: addressOfNextInstructionToGenerate - ADDRESS_SIZE
]

{ #category : #instructions }
BPAssembly >> nop [
	"No-op instruction, does nothing.
	"
	(BPInstruction
		from: 0
		to: 0
		jump: addressOfNextInstructionToGenerate + INSTRUCTION_SIZE) writeOn: self at: addressOfNextInstructionToGenerate memoryAddress.
	self incrementAddressOfNextInstructionToGenerate: INSTRUCTION_SIZE.
	self addReferenceToFutureMemory: addressOfNextInstructionToGenerate - ADDRESS_SIZE
]

{ #category : #accessing }
BPAssembly >> registerNamed: aSymbol [
	^ self registers detect: [ :register | register name = aSymbol ]
]

{ #category : #accessing }
BPAssembly >> registers [
	^ registers
]

{ #category : #accessing }
BPAssembly >> reservedMemoryZoneNamed: aSymbol [
	^ self reservedMemoryZones detect: [ :zone | zone name = aSymbol ]
]

{ #category : #accessing }
BPAssembly >> reservedMemoryZones [
	^ reservedMemoryZones
]

{ #category : #initialization }
BPAssembly >> resetReferencesToFutureMemory [
	referencesToFutureMemory := OrderedCollection new
]

{ #category : #instructions }
BPAssembly >> savePC [
	"Generates an instruction that saves the current value of PC in PC register.
	 This is required to handle subroutines.
	"
	"Will require an identity page (mem[EN00YZ] = YZ)."
	self flag: #TODO.
]

{ #category : #'as yet unclassified' }
BPAssembly >> serializeAddressOfNextInstructionToGenerate [
	addressOfNextInstructionToGenerate writeOn: self memory at: PROGRAM_COUNTER_ADDRESS
]

{ #category : #instructions }
BPAssembly >> writePixel: pixel [
	"Writes #pixelValue on the pixel at the address pointed by 16bits address formed by A and B registers.
	 A register holds middle byte for address.
	 B register holds lower byte for address.
	"
	| valueAddress |
	valueAddress := pixel forAssembly: self.
	(BPInstruction
		from: (self registerNamed: #A)
		to: addressOfNextInstructionToGenerate + (INSTRUCTION_SIZE * 2) + ADDRESS_SIZE + 1
		jump: addressOfNextInstructionToGenerate + INSTRUCTION_SIZE) writeOn: self at: addressOfNextInstructionToGenerate memoryAddress.
	(BPInstruction
		from: (self registerNamed: #B)
		to: addressOfNextInstructionToGenerate + (INSTRUCTION_SIZE * 2) + ADDRESS_SIZE + 2
		jump: addressOfNextInstructionToGenerate + (2*INSTRUCTION_SIZE)) writeOn: self at: (addressOfNextInstructionToGenerate + INSTRUCTION_SIZE) memoryAddress.
	(BPInstruction
		from: valueAddress
		to: (self reservedMemoryZoneNamed: #DISPLAY_FRAME) address
		jump: addressOfNextInstructionToGenerate + (3*INSTRUCTION_SIZE)) writeOn: self at: (addressOfNextInstructionToGenerate + (2*INSTRUCTION_SIZE)) memoryAddress.
	
	self incrementAddressOfNextInstructionToGenerate: (3*INSTRUCTION_SIZE).
	self addReferenceToFutureMemory: addressOfNextInstructionToGenerate - ADDRESS_SIZE.
]