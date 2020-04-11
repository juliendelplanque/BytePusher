"
I model the whole layout of BytePusher VM memory.
I am a composite object containing registers and reserved memory zones.
My purpose is to describe to the assembler how the memory is organized allowing it to know how to generate the bytecode.

My #startAddress and #endAddress are defined by BytePusher specifications.

I provide a nice API to manipulate my registers and reserved memory zones.

I also ensure that the memory layout built by my client is consistent (none of my layout objects overlap in the memory).

For an example of memory layout, check my class-side method #standard.
"
Class {
	#name : #BPMemoryLayout,
	#superclass : #BPLayoutObject,
	#instVars : [
		'layoutObjects'
	],
	#pools : [
		'BPConstants'
	],
	#category : #'BytePusher-Assembler-Memory'
}

{ #category : #factory }
BPMemoryLayout class >> jolly [
	<sampleInstance>
	| available_memory_start |
	available_memory_start := 9.
	^ self new
		name: 'JollyV1';
		addAll: {
		BPReservedMemoryZone name: #PROGRAM_COUNTER startAddress: 0 size: 2.
		BPRegister name: #PRIMITIVE_IS_READY address: 3.
		BPRegister name: #PRIMITIVE_CALL_ID address: 4.
		BPRegister name: #PRIMITIVE_RESULT_CODE address: 5.
		BPRegister name: #PRIMITIVE_RESULT_HIGH address: 6.
		BPRegister name: #PRIMITIVE_RESULT_MIDDLE address: 7.
		BPRegister name: #PRIMITIVE_RESULT_LOW address: 8.
		BPRegister name: #A address: available_memory_start.
		BPRegister name: #B address: available_memory_start + 1.
		BPRegister name: #C address: available_memory_start + 2.
		BPRegister name: #SP address: available_memory_start + 3.
		BPRegister name: #CARRY address: available_memory_start + 4.
		BPRegister name: #ZERO address: available_memory_start + 5.
		BPRegister name: #RETURN_SP address: available_memory_start + 6.
		BPReservedMemoryZone name: #JUMP_IF_ZERO startAddress: available_memory_start + 7 size: INSTRUCTION_SIZE.
		BPReservedMemoryZone name: #JUMP_IF_NONZERO startAddress: available_memory_start + 7 + INSTRUCTION_SIZE size: INSTRUCTION_SIZE.
		BPReservedMemoryZone name: #INFINITE_NOP startAddress: available_memory_start + 7 + (2 * INSTRUCTION_SIZE) size: INSTRUCTION_SIZE.
		BPRegister name: #D address: available_memory_start + 7 + (3 * INSTRUCTION_SIZE).
		BPRegister name: #E address: available_memory_start + 7 + (3 * INSTRUCTION_SIZE) + 1.
		BPRegister name: #F address: available_memory_start + 7 + (3 * INSTRUCTION_SIZE) + 2.
		BPRegister name: #G address: available_memory_start + 7 + (3 * INSTRUCTION_SIZE) + 3.
		BPAddBankBuilder reservedMemoryZoneStartingAt: 16r10000.
		BPAddZeroFlagBankBuilder reservedMemoryZoneStartingAt: 16r20000.
		BPAddCarryFlagBankBuilder reservedMemoryZoneStartingAt: 16r50000.
		BPCmpBankBuilder reservedMemoryZoneStartingAt: 16r30000.
		BPBitAndBankBuilder reservedMemoryZoneStartingAt: 16r80000.
		BPIdentityPageBuilder reservedMemoryZoneStartingAt: 16r40000.
		BPIncrementPageBuilder reservedMemoryZoneStartingAt: 16r40100.
		BPDecrementPageBuilder reservedMemoryZoneStartingAt: 16r40200.
		BPReservedMemoryZone name: #DATA_STACK startAddress: 16r40300 size: 16rFF.
		BPReservedMemoryZone name: #RETURN_STACK startAddress: 16r40400 size: 16rFF };
	yourself
]

{ #category : #adding }
BPMemoryLayout >> add: aLayoutObject [
	self ensureLayoutObjectDoesNotCreateConflict: aLayoutObject.
	layoutObjects add: aLayoutObject
]

{ #category : #adding }
BPMemoryLayout >> addAll: aCollectionOfLayoutObjects [
	aCollectionOfLayoutObjects do: [ :layoutObject |
		self add: layoutObject ]
]

{ #category : #accessing }
BPMemoryLayout >> endAddress [
	"The end address is the maximal address specified by BytePusher specifications."
	^ MAX_ADDRESS asBPAddress
]

{ #category : #private }
BPMemoryLayout >> ensureLayoutObjectDoesNotCreateConflict: aLayoutObject [
	self layoutObjects detect: [ :layoutObject |
		(aLayoutObject startAddress between: layoutObject startAddress and: layoutObject endAddress)
			or: [ (aLayoutObject endAddress between: layoutObject startAddress and: layoutObject endAddress) ] ]
		ifFound: [ :overlapingWith |
			self error: 'The layout object ',aLayoutObject name,' overlaps with an existing layout object ', overlapingWith name ].
		
	
]

{ #category : #extracting }
BPMemoryLayout >> extractDataStack: memory [
	^ (((self reservedMemoryZoneNamed: #DATA_STACK) access: memory)
			copyFrom: 1 to: ((self registerNamed: #SP) valueIn: memory)) reversed as: Stack
]

{ #category : #extracting }
BPMemoryLayout >> extractReturnStack: memory [
	"Returns a high-level object (instance of Stack) representing the return stack.
	 Instead of storing bytes of the address, instances of BPAddress are created to make
	 the content of the stack easier to understand.
	"
	^ ((((self reservedMemoryZoneNamed: #RETURN_STACK) access: memory)
			copyFrom: 1 to: ((self registerNamed: #RETURN_SP) valueIn: memory)) reversed groupsOf: 3 atATimeCollect: [ :low :middle :high |
				BPAddress lowByte: low middleByte: middle highByte: high ]) as: Stack
]

{ #category : #accessing }
BPMemoryLayout >> firstGenerationAddress [
	^ (self layoutObjects detectMax: #endAddress) endAddress + 1
]

{ #category : #initialization }
BPMemoryLayout >> initialize [
	super initialize.
	self layoutObjects: (SortedCollection sortBlock: [ :x :y | x startAddress < y startAddress ]).
]

{ #category : #'initialize memory' }
BPMemoryLayout >> initializeOpcodeBankMemoryZonesOn: aByteArray [
	self layoutObjects
		select: [ :layoutObject | 
			layoutObject isReservedMemoryZone and: [ layoutObject isForOpcodeBank ] ]
		thenDo: [ :opcodeBankReservedMemoryZone |
			opcodeBankReservedMemoryZone writeBankOn: aByteArray ]
]

{ #category : #accessing }
BPMemoryLayout >> layoutObjects [
	^ layoutObjects
]

{ #category : #accessing }
BPMemoryLayout >> layoutObjects: anObject [
	layoutObjects := anObject
]

{ #category : #accessing }
BPMemoryLayout >> registerNamed: aSymbol [
	^ self layoutObjects detect: [ :layoutObject |
		layoutObject isRegister and: [ layoutObject name = aSymbol ] ]
]

{ #category : #accessing }
BPMemoryLayout >> registers [
	^ self layoutObjects select: #isRegister
]

{ #category : #accessing }
BPMemoryLayout >> reservedMemoryZoneNamed: aSymbol [
	^ self layoutObjects detect: [ :layoutObject |
		layoutObject isReservedMemoryZone and: [ layoutObject name = aSymbol ] ]
]

{ #category : #accessing }
BPMemoryLayout >> startAddress [
	"Beginning of BytePusher memory, address is 0."
	^ 0 asBPAddress
]

{ #category : #accessing }
BPMemoryLayout >> typeName [
	^ 'Memory'
]
