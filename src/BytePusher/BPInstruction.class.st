Class {
	#name : #BPInstruction,
	#superclass : #Object,
	#instVars : [
		'address',
		'fromAddress',
		'toAddress',
		'jumpAddress'
	],
	#pools : [
		'BPConstants'
	],
	#category : #'BytePusher-Assembly'
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
BPInstruction >> fromAddress [
	^ fromAddress
]

{ #category : #accessing }
BPInstruction >> fromAddress: anObject [
	fromAddress := anObject
]

{ #category : #testing }
BPInstruction >> isInstruction [
	^ true
]

{ #category : #accessing }
BPInstruction >> jumpAddress [
	^ jumpAddress
]

{ #category : #accessing }
BPInstruction >> jumpAddress: anObject [
	jumpAddress := anObject
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
	self fromAddress writeOn: aBPAssembly memory at: addressToWriteOn.
	self toAddress writeOn: aBPAssembly memory at: addressToWriteOn + ADDRESS_SIZE.
	self jumpAddress writeOn: aBPAssembly memory at: addressToWriteOn + (ADDRESS_SIZE * 2)
]
