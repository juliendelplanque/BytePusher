Class {
	#name : #BPVirtualMachine,
	#superclass : #Object,
	#instVars : [
		'memory',
		'ioDriver',
		'programCounter'
	],
	#pools : [
		'BPConstants'
	],
	#category : #'BytePusher-Core'
}

{ #category : #'memory manipulation' }
BPVirtualMachine >> extract: n bytesStartingAt: startAddress [
	"Extract #n bytes starting at the #startAddress and returns the integer formed by those #n bytes concatenated.
	 #startAddress should be included between 0 and the memory size's - 1.
	 Example, if the memory is #[16rFF 16r0F 16r42 16r22], self extract: 2 bytesStartingAt: 2 returns 16r4222"
	| extracted |
	extracted := 16r0.
	startAddress to: startAddress + n - 1 do: [ :memoryIndex |
		extracted := (extracted << 8) | (self memoryAt: memoryIndex) ].
	^ extracted
]

{ #category : #initialization }
BPVirtualMachine >> initialize [
	super initialize.
	self
		resetMemory;
		ioDriver: BPIODriver default
]

{ #category : #running }
BPVirtualMachine >> innerStep [
	self
		memoryAt: (self extract: ADDRESS_SIZE bytesStartingAt: programCounter + 3)
		put: (self memoryAt: (self extract: ADDRESS_SIZE bytesStartingAt: programCounter)).
	
	programCounter := self
		extract: ADDRESS_SIZE
		bytesStartingAt: programCounter + 6
]

{ #category : #accessing }
BPVirtualMachine >> ioDriver [
	^ ioDriver
]

{ #category : #accessing }
BPVirtualMachine >> ioDriver: anObject [
	ioDriver := anObject
]

{ #category : #accessing }
BPVirtualMachine >> keyboardStateAddress [
	^ KEYBOARD_STATE_ADDRESS
]

{ #category : #'rom - loading' }
BPVirtualMachine >> loadROMFromFile: aFileReference [
	self resetMemory.
	aFileReference binaryReadStreamDo: [ :stream |
		|i|
		i := 0.
		[ stream atEnd ]
			whileFalse: [ 
				self memoryAt: i put: stream next.
				i := i + 1 ] ]
]

{ #category : #accessing }
BPVirtualMachine >> memory [
	^ memory
]

{ #category : #accessing }
BPVirtualMachine >> memory: anObject [
	memory := anObject
]

{ #category : #'memory manipulation' }
BPVirtualMachine >> memoryAt: anInteger [
	"Access the memory with index starting at 0 and finishing at self memory size - 1."
	^ self memory at: anInteger + 1
]

{ #category : #'memory manipulation' }
BPVirtualMachine >> memoryAt: anInteger put: aByte [
	"Set the memory with index starting at 0 and finishing at self memory size - 1."
	^ self memory at: anInteger + 1 put: aByte
]

{ #category : #'memory manipulation' }
BPVirtualMachine >> memoryAt: address putInteger: anInteger [
	"Write anInteger on the 3 consecutive bytes at address, address+1 and address+2.
	 Big endian encoding is used.
	"
	self
		memoryAt: address put: (anInteger & 16rFF0000) >> 16;
		memoryAt: address + 1 put: (anInteger & 16rFF00) >> 8;
		memoryAt: address + 2 put: (anInteger & 16rFF).
]

{ #category : #'memory manipulation' }
BPVirtualMachine >> memoryCopy: n bytesFrom: startAddress [
	"Returns a copy of a sub-range of the memory starting at #startAddress and of size #n."
	^ self memory copyFrom: startAddress + 1 to: startAddress + n
]

{ #category : #accessing }
BPVirtualMachine >> pixelPointerAddress [
	^ PIXEL_POINTER_ADDRESS
]

{ #category : #accessing }
BPVirtualMachine >> programCounter [
	^ programCounter
]

{ #category : #accessing }
BPVirtualMachine >> programCounter: anObject [
	programCounter := anObject
]

{ #category : #'memory manipulation' }
BPVirtualMachine >> resetMemory [
	self memory: (ByteArray new: MEMORY_SIZE)
]

{ #category : #running }
BPVirtualMachine >> step [
	| keyPressed |
	keyPressed := 0"self ioDriver keyPressed".
	self 
		memoryAt: KEYBOARD_STATE_ADDRESS put: (keyPressed >> 8) & 16rFF;
		memoryAt: KEYBOARD_STATE_ADDRESS + 1 put: keyPressed & 16rFF.
		
	programCounter :=  self extract: 3 bytesStartingAt: PROGRAM_COUNTER_ADDRESS.
	INSTRUCTIONS_PER_STEP 
		timesRepeat: [ self innerStep ].
	
	self ioDriver
		renderDisplayFrame: (self memoryCopy: PIXELS_COUNT bytesFrom: (self memoryAt: PIXEL_POINTER_ADDRESS) << 16).
	
]

{ #category : #accessing }
BPVirtualMachine >> userMemoryAddress [
	^ USER_MEMORY_ADDRESS
]
