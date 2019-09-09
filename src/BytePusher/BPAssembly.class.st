Class {
	#name : #BPAssembly,
	#superclass : #Object,
	#instVars : [
		'registers',
		'memory',
		'labels',
		'addressOfNextInstructionToGenerate',
		'firstMemoryAddress'
	],
	#pools : [
		'BPConstants'
	],
	#category : #'BytePusher-Assembly'
}

{ #category : #instructions }
BPAssembly >> add: source to: target [
	"Adds two numbers together or subtract one number form another.
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
		jump: addressOfNextInstructionToGenerate + INSTRUCTION_SIZE) writeOn: self memory at: addressOfNextInstructionToGenerate memoryAddress.
	(BPInstruction
		from: fromAddress
		to: addressOfNextInstructionToGenerate + 64
		jump: addressOfNextInstructionToGenerate + (2*INSTRUCTION_SIZE)) writeOn: self memory at: addressOfNextInstructionToGenerate memoryAddress + INSTRUCTION_SIZE.
	(BPInstruction
		from: fromAddress
		to: addressOfNextInstructionToGenerate + 73
		jump: addressOfNextInstructionToGenerate + (3*INSTRUCTION_SIZE)) writeOn: self memory at: addressOfNextInstructionToGenerate memoryAddress + (2*INSTRUCTION_SIZE).
	"Second, copy data at toAddress to location of the add, carry and zero instructions."
	(BPInstruction
		from: toAddress
		to: addressOfNextInstructionToGenerate + 56
		jump: addressOfNextInstructionToGenerate + (4*INSTRUCTION_SIZE)) writeOn: self memory at: addressOfNextInstructionToGenerate memoryAddress + (3*INSTRUCTION_SIZE).
	(BPInstruction
		from: toAddress
		to: addressOfNextInstructionToGenerate + 65
		jump: addressOfNextInstructionToGenerate + (5*INSTRUCTION_SIZE)) writeOn: self memory at: addressOfNextInstructionToGenerate memoryAddress + (4*INSTRUCTION_SIZE).
	(BPInstruction
		from: toAddress
		to: addressOfNextInstructionToGenerate + 74
		jump: addressOfNextInstructionToGenerate + (6*INSTRUCTION_SIZE)) writeOn: self memory at: addressOfNextInstructionToGenerate memoryAddress + (5*INSTRUCTION_SIZE).
	"Third, create the actual add instruction (beware the 16 least
	 significant bit of the #from address
	 will be set by the 2 previous instructions, so they it will be
	 overwritten at runtime whatever what is written on it).
	"
	(BPInstruction
		from: BPAddPageBuilder startAddress
		to: fromAddress
		jump: addressOfNextInstructionToGenerate + (7*INSTRUCTION_SIZE)) writeOn: self memory at: addressOfNextInstructionToGenerate memoryAddress + (6*INSTRUCTION_SIZE).
	"Fourth, create the actual carry flag instruction (beware the 16 least
	 significant bit of the #from address
	 will be set by the 2 previous instructions, so they it will be
	 overwritten at runtime whatever what is written on it).
	"
	(BPInstruction
		from: BPAddCarryFlagPageBuilder startAddress
		to: (self registerNamed: #CARRY)
		jump: addressOfNextInstructionToGenerate + (8*INSTRUCTION_SIZE)) writeOn: self memory at: addressOfNextInstructionToGenerate memoryAddress + (7*INSTRUCTION_SIZE).
	"Third, create the actual zero flag instruction (beware the 16 least
	 significant bit of the #from address
	 will be set by the 2 previous instructions, so they it will be
	 overwritten at runtime whatever what is written on it).
	"
	(BPInstruction
		from: BPAddZeroFlagPageBuilder startAddress
		to: (self registerNamed: #ZERO)
		jump: addressOfNextInstructionToGenerate + (9*INSTRUCTION_SIZE)) writeOn: self memory at: addressOfNextInstructionToGenerate memoryAddress + (8*INSTRUCTION_SIZE).
	addressOfNextInstructionToGenerate := addressOfNextInstructionToGenerate + (9*INSTRUCTION_SIZE)
]

{ #category : #adding }
BPAssembly >> addLabel: aBPLabel [
	(registers noneSatisfy: [ :r | r name = aBPLabel label ])
		ifFalse: [ self error: 'A register is already named ' , aBPLabel label ].
		
	(labels noneSatisfy: [ :l | l label = aBPLabel label ])
		ifFalse: [ self error: 'A label is already named ' , aBPLabel label ].
		
	labels add: aBPLabel
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
		to: addressOfNextInstructionToGenerate + 19
		jump: addressOfNextInstructionToGenerate + INSTRUCTION_SIZE) writeOn: self memory at: addressOfNextInstructionToGenerate memoryAddress.
	(BPInstruction
		from: yAddress
		to: addressOfNextInstructionToGenerate + 20
		jump: addressOfNextInstructionToGenerate + (2*INSTRUCTION_SIZE)) writeOn: self memory at: (addressOfNextInstructionToGenerate + INSTRUCTION_SIZE) memoryAddress.
	(BPInstruction
		from: BPCmpPageBuilder startAddress
		to: (self registerNamed: #ZERO)
		jump: addressOfNextInstructionToGenerate + (3*INSTRUCTION_SIZE)) writeOn: self memory at: (addressOfNextInstructionToGenerate + (2*INSTRUCTION_SIZE)) memoryAddress.
	addressOfNextInstructionToGenerate := addressOfNextInstructionToGenerate + (3*INSTRUCTION_SIZE)
	
]

{ #category : #instructions }
BPAssembly >> db: constant [
	"Defines a variable. A variable can either be a single number, character or a string.

	DB constant
	"
	self shouldBeImplemented
]

{ #category : #testing }
BPAssembly >> hasMemoryBeenWritten [
	^ addressOfNextInstructionToGenerate ~= firstMemoryAddress
]

{ #category : #initialization }
BPAssembly >> initialize [
	super initialize.
	registers := { 
		BPRegister name: #A address: USER_MEMORY_ADDRESS.
		BPRegister name: #B address: USER_MEMORY_ADDRESS + 1.
		BPRegister name: #C address: USER_MEMORY_ADDRESS + 2.
		BPRegister name: #D address: USER_MEMORY_ADDRESS + 3.
		BPRegister name: #SP address: USER_MEMORY_ADDRESS + 4.
		BPRegister name: #CARRY address: USER_MEMORY_ADDRESS + 5.
		BPRegister name: #ZERO address: USER_MEMORY_ADDRESS + 6 }.
		
	addressOfNextInstructionToGenerate := (registers detectMax: #address) address + 1.
	self serializeAddressOfNextInstructionToGenerate.
	
	labels := OrderedCollection new.
]

{ #category : #initialization }
BPAssembly >> initializeMemory [
	memory := ByteArray new: MEMORY_SIZE.
	BPAddPageBuilder writeBankOn: memory.
	BPAddCarryFlagPageBuilder writeBankOn: memory.
	BPAddZeroFlagPageBuilder writeBankOn: memory.
	BPCmpPageBuilder writeBankOn: memory.
	^ memory
]

{ #category : #instructions }
BPAssembly >> jump: address [
	"Let the instruction pointer do a unconditional jump to the defined address.

	 JMP address
	"
	| jmpAddress |
	jmpAddress := address asBPAddress.
	(BPInstruction
		from: 0
		to: 0
		jump: jmpAddress) writeOn: self memory at: addressOfNextInstructionToGenerate memoryAddress.
	addressOfNextInstructionToGenerate := addressOfNextInstructionToGenerate + INSTRUCTION_SIZE.
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
		jump: addressForNotEqual >> 8 << 8) writeOn: self memory at: addressOfNextInstructionToGenerate memoryAddress.
	
	addressOfNextInstructionToGenerate := addressForNotEqual.
	(BPInstruction
		from: 0
		to: 0
		jump: jmpAddress) writeOn: self memory at: addressOfNextInstructionToGenerate memoryAddress.
		
	addressOfNextInstructionToGenerate := addressForEqual.
	(BPInstruction
		from: 0
		to: 0
		jump: addressOfNextInstructionToGenerate + INSTRUCTION_SIZE) writeOn: self memory at: addressOfNextInstructionToGenerate memoryAddress.
	addressOfNextInstructionToGenerate := addressOfNextInstructionToGenerate + INSTRUCTION_SIZE
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
		jump: addressOfNextInstructionToGenerate + INSTRUCTION_SIZE) writeOn: self memory at: addressOfNextInstructionToGenerate memoryAddress.
	addressOfNextInstructionToGenerate := addressOfNextInstructionToGenerate + INSTRUCTION_SIZE.
]

{ #category : #instructions }
BPAssembly >> nop [
	"No-op instruction, does nothing.
	"
	(BPInstruction
		from: 0
		to: 0
		jump: addressOfNextInstructionToGenerate + INSTRUCTION_SIZE) writeOn: self memory at: addressOfNextInstructionToGenerate memoryAddress.
	addressOfNextInstructionToGenerate := addressOfNextInstructionToGenerate + INSTRUCTION_SIZE.
]

{ #category : #accessing }
BPAssembly >> registerNamed: aSymbol [
	^ self registers detect: [ :register | register name = aSymbol ]
]

{ #category : #accessing }
BPAssembly >> registers [
	^ registers
]

{ #category : #'as yet unclassified' }
BPAssembly >> serializeAddressOfNextInstructionToGenerate [
	addressOfNextInstructionToGenerate writeOn: self memory at: 2.
	firstMemoryAddress := addressOfNextInstructionToGenerate.
]
