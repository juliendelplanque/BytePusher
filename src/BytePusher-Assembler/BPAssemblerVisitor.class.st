Class {
	#name : #BPAssemblerVisitor,
	#superclass : #Object,
	#instVars : [
		'memoryLayout'
	],
	#category : #'BytePusher-Assembler-Visitors'
}

{ #category : #visiting }
BPAssemblerVisitor class >> visit: anObject [
	^ self new visit: anObject
]

{ #category : #accessing }
BPAssemblerVisitor >> memoryLayout [
	^ memoryLayout
]

{ #category : #accessing }
BPAssemblerVisitor >> memoryLayout: anObject [
	memoryLayout := anObject
]

{ #category : #visiting }
BPAssemblerVisitor >> visit: anObject [
	<generated>
	^ anObject acceptVisitor: self
]

{ #category : #visiting }
BPAssemblerVisitor >> visitBPAddress: aBPAddress [
	<generated>
	^ self subclassResponsibility
]

{ #category : #visiting }
BPAssemblerVisitor >> visitBPAddressDataAccess: aBPAddressDataAccess [
	<generated>
	^ self subclassResponsibility
]

{ #category : #visiting }
BPAssemblerVisitor >> visitBPAddressDataReference: aBPAddressDataReference [
	<generated>
	^ self subclassResponsibility
]

{ #category : #visiting }
BPAssemblerVisitor >> visitBPAssembler: aBPAssembler [
	self memoryLayout: aBPAssembler memoryLayout.
]

{ #category : #visiting }
BPAssemblerVisitor >> visitBPInstructionToResolve: aBPInstructionToResolve [
	<generated>
	^ self subclassResponsibility
]

{ #category : #visiting }
BPAssemblerVisitor >> visitBPLabel: aBPLabel [
	<generated>
	^ self subclassResponsibility
]

{ #category : #visiting }
BPAssemblerVisitor >> visitBPLabelReference: aBPLabelReference [
	<generated>
	^ self subclassResponsibility
]

{ #category : #visiting }
BPAssemblerVisitor >> visitBPNextInstructionReference: aBPNextInstructionReference [
	<generated>
	^ self subclassResponsibility
]

{ #category : #visiting }
BPAssemblerVisitor >> visitBPOffsetReference: aBPOffsetReference [
	<generated>
	^ self subclassResponsibility
]

{ #category : #visiting }
BPAssemblerVisitor >> visitBPReferenceToInstruction: aBPReferenceToInstruction [
	<generated>
	^ self subclassResponsibility
]

{ #category : #visiting }
BPAssemblerVisitor >> visitBPRegister: aBPRegister [
	<generated>
	^ self subclassResponsibility
]

{ #category : #visiting }
BPAssemblerVisitor >> visitBPReservedMemoryZone: aBPReservedMemoryZone [
	<generated>
	^ self subclassResponsibility
]
