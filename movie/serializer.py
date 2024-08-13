from rest_framework import serializers
from .models import Movie
from django.core.validators import MaxLengthValidator, MinLengthValidator
from rest_framework.serializers import ValidationError


def overview_validator(value):
    if len(value) > 300:
        raise ValidationError('소개 문구는 최대 300자 이하로 작성해야 합니다.')
    elif len(value) < 10:
        raise ValidationError('소개 문구는 최소 10자 이상으로 작성해야 합니다.')
    return value

class MovieSerializer(serializers.ModelSerializer):
    overview = serializers.CharField(validators = [overview_validator])
    running_time = serializers.DurationField()
    
    class Meta:
        model = Movie
        fields = ['id', 'name', 'opening_date', 'running_time', 'overview']