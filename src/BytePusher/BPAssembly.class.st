Class {
	#name : #BPAssembly,
	#superclass : #Object,
	#instVars : [
		'registers',
		'memory',
		'addressOfNextInstructionToGenerate'
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

{ #category : #accessing }
BPAssembly >> addressOfNextInstructionToGenerate [
	^ addressOfNextInstructionToGenerate
]

{ #category : #accessing }
BPAssembly >> addressOfNextInstructionToGenerate: anObject [
	addressOfNextInstructionToGenerate := anObject
]

{ #category : #instructions }
BPAssembly >> db: constant [
	"Defines a variable. A variable can either be a single number, character or a string.

	DB constant
	"
	self shouldBeImplemented
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
	addressOfNextInstructionToGenerate writeOn: self memory at: 2.
]

{ #category : #initialization }
BPAssembly >> initializeMemory [
	memory := ByteArray new: MEMORY_SIZE.
	BPAddPageBuilder writeBankOn: memory.
	BPAddCarryFlagPageBuilder writeBankOn: memory.
	BPAddZeroFlagPageBuilder writeBankOn: memory.
	^ memory
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

{ #category : #accessing }
BPAssembly >> registerNamed: aSymbol [
	^ self registers detect: [ :register | register name = aSymbol ]
]

{ #category : #accessing }
BPAssembly >> registers [
	^ registers
]
