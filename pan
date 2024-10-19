using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Управление_машиной : MonoBehaviour
{
    public float acceleration = 30f;
    public float maxSpeed = 100f;
    public float steering = 50f;
    public float driftFactor = 0.95f;
    public float handbrakeFactor = 0.5f;
    public float deceleration = 5f; 
    public float friction = 0.98f; 

    private float currentSpeed = 0f;
    private float steeringInput = 0f;
    private bool isHandbrake = false;

    private Rigidbody rb;

    void Start()
    {
        rb = GetComponent<Rigidbody>();
    }

    void Update()
    {
        HandleInput();
    }

    void FixedUpdate()
    {
        HandleMovement();
    }

    void HandleInput()
    {
        float forwardInput = Input.GetKey(KeyCode.W) ? 1 : Input.GetKey(KeyCode.S) ? -1 : 0;
        steeringInput = Input.GetKey(KeyCode.A) ? -1 : Input.GetKey(KeyCode.D) ? 1 : 0;

        isHandbrake = Input.GetKey(KeyCode.Space);

        if (forwardInput != 0)
        {
            currentSpeed += forwardInput * acceleration * Time.deltaTime;
            currentSpeed = Mathf.Clamp(currentSpeed, -maxSpeed, maxSpeed);
        }
        else
        {
            currentSpeed = Mathf.Lerp(currentSpeed, currentSpeed * friction, deceleration * Time.deltaTime); // плавное замедление
        }
    }

    void HandleMovement()
    {
        Vector3 forward = transform.forward;
        Vector3 velocity = rb.velocity;

        if (isHandbrake)
        {
            velocity = Vector3.Lerp(velocity, Vector3.zero, handbrakeFactor * Time.deltaTime);
        }

        rb.velocity = forward * currentSpeed + (velocity - forward * Vector3.Dot(velocity, forward)) * driftFactor;
        rb.MoveRotation(rb.rotation * Quaternion.Euler(0, steeringInput * steering * Time.deltaTime, 0));
    }
}
