Class {
	#name : #BPAssembly,
	#superclass : #Object,
	#instVars : [
		'registers',
		'lastBPInstructionIndex',
		'memory'
	],
	#pools : [
		'BPConstants'
	],
	#category : #'BytePusher-Assembly'
}

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
		BPRegister name: #FLAGS address: USER_MEMORY_ADDRESS + 5 }.
		
	lastBPInstructionIndex := (registers detectMax: #address) address.
]

{ #category : #accessing }
BPAssembly >> lastBPInstructionIndex [
	^ lastBPInstructionIndex
]

{ #category : #accessing }
BPAssembly >> lastBPInstructionIndex: anObject [
	lastBPInstructionIndex := anObject
]

{ #category : #accessing }
BPAssembly >> memory [
	^ memory ifNil: [ memory := ByteArray new: MEMORY_SIZE ]
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
	lastBPInstructionIndex := lastBPInstructionIndex + INSTRUCTION_SIZE.
	(BPInstruction
		from: fromAddress
		to: toAddress
		jump: lastBPInstructionIndex + INSTRUCTION_SIZE) writeOn: self memory at: lastBPInstructionIndex memoryAddress.
]

{ #category : #accessing }
BPAssembly >> registerNamed: aSymbol [
	^ self registers detect: [ :register | register name = aSymbol ]
]

{ #category : #accessing }
BPAssembly >> registers [
	^ registers
]
