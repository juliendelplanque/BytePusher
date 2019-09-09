Class {
	#name : #BPInstruction,
	#superclass : #Object,
	#instVars : [
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
BPInstruction class >> from: from to: to jump: jump [
	^ self new
		fromAddress: from asBPAddress;
		toAddress: to asBPAddress;
		jumpAddress: jump asBPAddress;
		yourself
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

{ #category : #accessing }
BPInstruction >> toAddress [
	^ toAddress
]

{ #category : #accessing }
BPInstruction >> toAddress: anObject [
	toAddress := anObject
]

{ #category : #writing }
BPInstruction >> writeOn: aBPAssembly at: address [
	self fromAddress writeOn: aBPAssembly memory at: address.
	self toAddress writeOn: aBPAssembly memory at: address + ADDRESS_SIZE.
	self jumpAddress writeOn: aBPAssembly memory at: address + (ADDRESS_SIZE * 2)
]
