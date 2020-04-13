"
I model the whole layout of BytePusher VM memory.

I follow BytePusher specification to describe memory.
"
Class {
	#name : #BPBytePusherLayout,
	#superclass : #BPMemoryLayout,
	#category : #'BytePusher-Assembler-Memory'
}

{ #category : #accessing }
BPBytePusherLayout >> endAddress [
	"The end address is the maximal address specified by BytePusher specifications."
	^ MAX_ADDRESS asBPAddress
]

{ #category : #extracting }
BPBytePusherLayout >> extractDataStack: memory [
	^ (((self reservedMemoryZoneNamed: #DATA_STACK) access: memory)
			copyFrom: 1 to: ((self registerNamed: #SP) valueIn: memory)) reversed as: Stack
]

{ #category : #extracting }
BPBytePusherLayout >> extractReturnStack: memory [
	"Returns a high-level object (instance of Stack) representing the return stack.
	 Instead of storing bytes of the address, instances of BPAddress are created to make
	 the content of the stack easier to understand.
	"
	^ ((((self reservedMemoryZoneNamed: #RETURN_STACK) access: memory)
			copyFrom: 1 to: ((self registerNamed: #RETURN_SP) valueIn: memory)) reversed groupsOf: 3 atATimeCollect: [ :low :middle :high |
				BPAddress lowByte: low middleByte: middle highByte: high ]) as: Stack
]

{ #category : #initialization }
BPBytePusherLayout >> initialize [
	super initialize.
	self
		name: 'BytePusher';
		addAll: {
		BPRegister name: #KEYBOARD_HIGH address: KEYBOARD_STATE_ADDRESS.
		BPRegister name: #KEYBOARD_LOW address: KEYBOARD_STATE_ADDRESS + 1.
		BPReservedMemoryZone name: #PROGRAM_COUNTER startAddress: PROGRAM_COUNTER_ADDRESS size: ADDRESS_SIZE.
		BPReservedMemoryZone name: #DISPLAY_FRAME_POINTER startAddress: PIXEL_POINTER_ADDRESS size: 1.
		BPReservedMemoryZone name: #AUDIO_SAMPLE_POINTER startAddress: AUDIO_POINTER_ADDRESS size: 2.
		BPRegister name: #A address: USER_MEMORY_ADDRESS.
		BPRegister name: #B address: USER_MEMORY_ADDRESS + 1.
		BPRegister name: #C address: USER_MEMORY_ADDRESS + 2.
		BPRegister name: #D address: USER_MEMORY_ADDRESS + 3.
		BPRegister name: #SP address: USER_MEMORY_ADDRESS + 4.
		BPRegister name: #CARRY address: USER_MEMORY_ADDRESS + 5.
		BPRegister name: #ZERO address: USER_MEMORY_ADDRESS + 6.
		BPRegister name: #RETURN_SP address: USER_MEMORY_ADDRESS + 7.
		BPReservedMemoryZone name: #JUMP_IF_ZERO startAddress: USER_MEMORY_ADDRESS + 8 size: INSTRUCTION_SIZE.
		BPReservedMemoryZone name: #JUMP_IF_NONZERO startAddress: USER_MEMORY_ADDRESS + 8 + INSTRUCTION_SIZE size: INSTRUCTION_SIZE.
		BPReservedMemoryZone name: #INFINITE_NOP startAddress: USER_MEMORY_ADDRESS + 8 + (2 * INSTRUCTION_SIZE) size: INSTRUCTION_SIZE.
		BPRegister name: #E address: USER_MEMORY_ADDRESS + 8 + (3 * INSTRUCTION_SIZE).
		BPRegister name: #F address: USER_MEMORY_ADDRESS + 8 + (3 * INSTRUCTION_SIZE) + 1.
		BPReservedMemoryZone name: #DISPLAY_FRAME startAddress: 16r60000 size: PIXELS_COUNT.
		BPReservedMemoryZone name: #AUDIO_SAMPLE startAddress: 16r70000 size: AUDIO_SAMPLE_SIZE.
		BPAddBankBuilder reservedMemoryZoneStartingAt: 16r10000.
		BPAddZeroFlagBankBuilder reservedMemoryZoneStartingAt: 16r20000.
		BPAddCarryFlagBankBuilder reservedMemoryZoneStartingAt: 16r50000.
		BPCmpBankBuilder reservedMemoryZoneStartingAt: 16r30000.
		BPBitAndBankBuilder reservedMemoryZoneStartingAt: 16r80000.
		BPIdentityPageBuilder reservedMemoryZoneStartingAt: 16r40000.
		BPIncrementPageBuilder reservedMemoryZoneStartingAt: 16r40100.
		BPDecrementPageBuilder reservedMemoryZoneStartingAt: 16r40200.
		BPReservedMemoryZone name: #DATA_STACK startAddress: 16r40300 size: 16rFF.
		BPReservedMemoryZone name: #RETURN_STACK startAddress: 16r40400 size: 16rFF }
]

{ #category : #'initialize memory' }
BPBytePusherLayout >> initializeMemory: aByteArray [
	super initializeMemory: aByteArray.
	"Create the infinite NOP loop."
	((self reservedMemoryZoneNamed: #INFINITE_NOP) startAddress + (2 * ADDRESS_SIZE))
		storeAddress: (self reservedMemoryZoneNamed: #INFINITE_NOP) startAddress in: aByteArray.
	
	(self reservedMemoryZoneNamed: #DISPLAY_FRAME_POINTER) address
		store: (self reservedMemoryZoneNamed: #DISPLAY_FRAME) address higherByte in: aByteArray.
	(self reservedMemoryZoneNamed: #AUDIO_SAMPLE_POINTER) address
		store: (self reservedMemoryZoneNamed: #AUDIO_SAMPLE) address higherByte in: aByteArray.
	(self reservedMemoryZoneNamed: #AUDIO_SAMPLE_POINTER) address + 1
		store: (self reservedMemoryZoneNamed: #AUDIO_SAMPLE) address middleByte in: aByteArray
]
