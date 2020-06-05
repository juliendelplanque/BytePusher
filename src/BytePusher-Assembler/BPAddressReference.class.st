Class {
	#name : #BPAddressReference,
	#superclass : #BPReferenceToEntityWithAddress,
	#category : #'BytePusher-Assembler-Model'
}

{ #category : #'instance creation' }
BPAddressReference class >> address: address byteIndex: byteIndex [
	^ self new
		address: address;
		offset: byteIndex;
		yourself
]

{ #category : #visiting }
BPAddressReference >> acceptVisitor: aBPAssemblerVisitor [
	<generated>
	^ aBPAssemblerVisitor visitBPAddressDataAccess: self
]
