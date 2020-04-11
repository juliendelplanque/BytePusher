Class {
	#name : #BPInstruction,
	#superclass : #Object,
	#instVars : [
		'address',
		'fromAddress',
		'toAddress',
		'jumpAddress',
		'assemblerInstruction'
	],
	#pools : [
		'BPConstants'
	],
	#category : #'BytePusher-Assembler-Model'
}

{ #category : #'instance creation' }
BPInstruction class >> address: address from: from to: to jump: jump [
	^ self new
		address: address;
		fromAddress: from;
		toAddress: to;
		jumpAddress: jump;
		yourself
]

{ #category : #'instance creation' }
BPInstruction class >> from: from to: to jump: jump [
	^ self new
		fromAddress: from asBPAddress;
		toAddress: to asBPAddress;
		jumpAddress: jump asBPAddress;
		yourself
]

{ #category : #accessing }
BPInstruction >> address [
	^ address
]

{ #category : #accessing }
BPInstruction >> address: anObject [
	address := anObject
]

{ #category : #accessing }
BPInstruction >> assemblerInstruction [
	^ assemblerInstruction
]

{ #category : #accessing }
BPInstruction >> assemblerInstruction: anObject [
	assemblerInstruction := anObject
]

{ #category : #assembling }
BPInstruction >> beAssembledIn: aBPAssembledCode [ 
	aBPAssembledCode addInstruction: self
]

{ #category : #accessing }
BPInstruction >> endAddress [
	"Returns the last address that this instruction occupies in memory."
	^ self address + INSTRUCTION_SIZE
]

{ #category : #accessing }
BPInstruction >> fromAddress [
	^ fromAddress
]

{ #category : #accessing }
BPInstruction >> fromAddress: anObject [
	fromAddress := anObject
]

{ #category : #accessing }
BPInstruction >> jumpAddress [
	^ jumpAddress
]

{ #category : #accessing }
BPInstruction >> jumpAddress: anObject [
	jumpAddress := anObject
]

{ #category : #printing }
BPInstruction >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: self address hex.
	aStream nextPut: $,.
	aStream nextPutAll: self fromAddress hex.
	aStream nextPut: $,.
	aStream nextPutAll: self toAddress hex.
	aStream nextPut: $,.
	aStream nextPutAll: self jumpAddress hex.
	aStream nextPut: $)
]

{ #category : #accessing }
BPInstruction >> tag [
	^ self assemblerInstruction tag
]

{ #category : #accessing }
BPInstruction >> toAddress [
	^ toAddress
]

{ #category : #accessing }
BPInstruction >> toAddress: anObject [
	toAddress := anObject
]

{ #category : #writing }
BPInstruction >> writeOn: aByteArray [
	self address storeAddress: self fromAddress in: aByteArray.
	self address + ADDRESS_SIZE storeAddress: self toAddress in: aByteArray.
	self address + (ADDRESS_SIZE * 2) storeAddress: self jumpAddress in: aByteArray
]

{ #category : #writing }
BPInstruction >> writeOn: aBPAssembly at: addressToWriteOn [
	self deprecated: 'Was used in old assembler.'.
	self fromAddress writeOn: aBPAssembly memory at: addressToWriteOn.
	self toAddress writeOn: aBPAssembly memory at: addressToWriteOn + ADDRESS_SIZE.
	self jumpAddress writeOn: aBPAssembly memory at: addressToWriteOn + (ADDRESS_SIZE * 2)
]
