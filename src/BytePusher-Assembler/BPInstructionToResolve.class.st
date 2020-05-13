Class {
	#name : #BPInstructionToResolve,
	#superclass : #Object,
	#instVars : [
		'from',
		'to',
		'jump',
		'address',
		'assemblerInstruction'
	],
	#category : #'BytePusher-Assembler-Model'
}

{ #category : #'instance creation' }
BPInstructionToResolve class >> from: from to: to jump: jump [
	^ self new
		from: from;
		to: to;
		jump: jump;
		yourself
]

{ #category : #visiting }
BPInstructionToResolve >> acceptVisitor: aBPAssemblerVisitor [
	<generated>
	^ aBPAssemblerVisitor visitBPInstructionToResolve: self
]

{ #category : #accessing }
BPInstructionToResolve >> address [
	^ address
]

{ #category : #accessing }
BPInstructionToResolve >> address: anObject [
	address := anObject
]

{ #category : #converting }
BPInstructionToResolve >> asReference [
	^ BPInstructionReference instruction: self
]

{ #category : #accessing }
BPInstructionToResolve >> assemblerInstruction [
	^ assemblerInstruction
]

{ #category : #accessing }
BPInstructionToResolve >> assemblerInstruction: anObject [
	assemblerInstruction := anObject
]

{ #category : #adding }
BPInstructionToResolve >> beAddedTo: anAssembler [
	anAssembler addInstruction: self
]

{ #category : #accessing }
BPInstructionToResolve >> from [
	^ from
]

{ #category : #accessing }
BPInstructionToResolve >> from: anObject [
	from := anObject
]

{ #category : #testing }
BPInstructionToResolve >> isInstructionToResolve [
	^ true
]

{ #category : #accessing }
BPInstructionToResolve >> jump [
	^ jump
]

{ #category : #accessing }
BPInstructionToResolve >> jump: anObject [
	jump := anObject
]

{ #category : #accessing }
BPInstructionToResolve >> to [
	^ to
]

{ #category : #accessing }
BPInstructionToResolve >> to: anObject [
	to := anObject
]
