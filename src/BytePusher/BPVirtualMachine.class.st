Class {
	#name : #BPVirtualMachine,
	#superclass : #Object,
	#instVars : [
		'memory',
		'ioDriver'
	],
	#category : #BytePusher
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

{ #category : #accessing }
BPVirtualMachine >> ioDriver [
	^ ioDriver
]

{ #category : #accessing }
BPVirtualMachine >> ioDriver: anObject [
	ioDriver := anObject
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
BPVirtualMachine >> memoryCopy: n bytesFrom: startAddress [
	"Returns a copy of a sub-range of the memory starting at #startAddress and of size #n."
	^ self memory copyFrom: startAddress + 1 to: startAddress + n
]

{ #category : #'memory manipulation' }
BPVirtualMachine >> resetMemory [
	self memory: (ByteArray new: 16r1000008)
]

{ #category : #running }
BPVirtualMachine >> run [
	| keyPressed instructionsLeftToExecute programCounter |
	keyPressed := 0"self ioDriver keyPressed".
	self memory
		at: 1 put: (keyPressed >> 8) & 16rFF;
		at: 2 put: keyPressed & 16rFF.
		
	instructionsLeftToExecute := 16r10000.
	programCounter :=  self extract: 3 bytesStartingAt: 2.
	[ (instructionsLeftToExecute := instructionsLeftToExecute - 1) = 0 ]
		whileFalse: [ 
			self
				memoryAt: (self extract: 3 bytesStartingAt: programCounter + 3)
				put: (self memoryAt: (self extract: 3 bytesStartingAt: programCounter)).
			programCounter := self extract: 3 bytesStartingAt: programCounter + 6 ].
	
	self ioDriver renderDisplayFrame: (self memoryCopy: 256 * 256 bytesFrom: (self extract: 1 bytesStartingAt: 5) << 16).
	
]
